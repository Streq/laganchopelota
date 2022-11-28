extends Node2D

"""
Bueno, la lógica en principio es como en both_sides_rope_sweep.gd:

CASO 1
MUEVO LA SOGA SIN ENROSCAR

-cuando muevo ambos extremos de la soga, se forma un cuadrilatero (par de triangulos si es cruzado)
-se buscan colisiones en esa área
-para cada punto de la colisión, se busca si está dentro del área
-se ordenan los puntos por orden de chocada
-el primer punto con el que se choca divide la soga en los dos extremos y el nuevo punto enroscado
-se continua analizando cada extremo como movimiento triangular


CASO 2
MUEVO LA SOGA ESTANDO ENROSCADA
-se analiza el movimiento de un extremo, despues el otro, siguiendo el algoritmo de punto fijo
-si la soga se desenrosca cuando uno de los 2 se esta moviendo y falta el otro, se sigue igual
-es decir, cuando finaliza el movimiento triangular de un extremo, inicia el triangular del otro

"""

var line_points := PoolVector2Array([Vector2(), Vector2()])

func step(B0:Vector2, B1:Vector2):
	var B0_moved = B0 != line_points[0]
	var B1_moved = B1 != line_points[-1]
	
	
	if B0_moved and B1_moved:
		if line_points.size()==2:
			solve_cuadrilateral_step(B0,B1)
		else:
			solve_triangular_step_B0(B0)
			solve_triangular_step_B1(B1)
	if B0_moved:
		solve_triangular_step_B0(B0)
	if B1_moved:
		solve_triangular_step_B1(B1)
	
	pass
	
	
func solve_triangular_step_B0(B0:Vector2):
	
	pass

func solve_cuadrilateral_step(B0:Vector2,B1:Vector2):
	pass

var latest_non_zero_side_of_swing0 := 0.0
var latest_non_zero_side_of_swing1 := 0.0

func solve_triangular_step_B1(B:Vector2) -> bool:
	var O = line_points[-2]
	var A = line_points[-1] #rope pre swing position
	line_points[-1] = B
	#       .O
	#	   / \
	#	  /   \
	#	 /     \
	#	/       \
	#  .A        .B
	
	while true:
		
		if A==B:
			return false
		O = line_points[-2] #rope latest split position (or rope origin if no splits)
		if line_points.size()>=3:
			#rope previous split position
			var Q := line_points[-3]
			
			#intersection between QO's line and AB
			#U is null if no intersection or same line
			var U = Geometry.line_intersects_line_2d(Q,O-Q,A,B-A)
			var parallel_swing = U == null
			var A_is_right_at_the_middle = Geometry.line_intersects_line_2d(O,A-O,Q,O-Q) == null
			var current_side_of_swing = RopeUtils.get_side_of_swing(Q,O,A)
			if current_side_of_swing:
				latest_non_zero_side_of_swing1 = current_side_of_swing
			if parallel_swing and A_is_right_at_the_middle:
				#       .Q
				#       |
				#       |
				#       .O
				#	    |
				#	    .A
				#	    |   AB is in the same line as QO
				#	    |
				#       .B
				return true
			elif RopeUtils.is_swing_from_side_to_middle(Q,O,A,B):
				#       .Q
				#       |
				#       |
				#       .O
				#	   /|
				#	  / |
				#	 /  |
				#	/   |
				#  .A   .B
				
				
				if check_splits(A,B):
					Q = line_points[-3]
					O = line_points[-2]
					latest_non_zero_side_of_swing1 = RopeUtils.get_side_of_full_swing(Q,O,A,B)
				
				return true
			elif RopeUtils.is_swing_from_middle_to_side(Q,O,A,B):
				#       .Q
				#       |
				#       |
				#       .O
				#	    |\
				#	    | \
				#	    |  \
				#	    |   \
				#       .A   .B
				if latest_non_zero_side_of_swing1 != RopeUtils.get_side_of_swing(Q,O,B):
#					join_last_two()
					continue
				
				return true
			elif RopeUtils.is_swing_from_side_to_side(Q,O,A,B):
				#       .Q
				#       |
				#       |
				#       .O
				#	   /.\
				#	  / . \
				#	 /  .  \
				#	/   .   \
				#  .A   .U   .B
				if !check_splits(A,U):
#					join_last_two()
					A = U
					continue
				check_splits(U,B)
				return true
			else:
				#.Q_____.O..............(U isn't inside AB)
				#	   / \
				#	  /   \
				#	 /     \
				#	/       \
				#  .A        .B
				check_splits(A,B)
				return true
		else:
			#       .O
			#	   / \
			#	  /   \
			#	 /     \
			#	/       \
			#  .A        .B
			if check_splits(A,B):
				var Q = line_points[-3]
				O = line_points[-2]
				latest_non_zero_side_of_swing1 = RopeUtils.get_side_of_full_swing(Q,O,A,B)
			return true
			
		
	return true


func check_splits(A:Vector2,B:Vector2):
	var O :Vector2 = line_points[-2]
#	draw_triangles.append(PoolVector2Array([O,A,B]))
	
	var points_in_triangle = get_all_collider_points_inside_triangle(O,A,B)
	if points_in_triangle.empty():
		return false
	
	if points_in_triangle.size()==1:
		var point = points_in_triangle[0]
		var valid = check_single_split(point)
		if valid:
			split_at_new(point)
		return valid
		
	var comparator = PointComparatorByAngleWithSegment.new(O,A)
	points_in_triangle.sort_custom(comparator, "compare_points_asc")
	var current_square_dist = 0
	var at_least_one_split = false
	for p in points_in_triangle:
		draw_collided_points.append(p)
		var point :Vector2 = p
		draw_internal_triangles.append(PoolVector2Array([A,B,line_points[-2]]))
		if (
			point_is_inside_triangle_inclusive_but_exclude_first_segment(p,line_points[-2],A,B)
			and check_single_split(point)
		):
			split_at_new(point)
			at_least_one_split = true
	
	return at_least_one_split
