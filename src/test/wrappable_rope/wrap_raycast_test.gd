extends Node2D

onready var line: Line2D = $line
onready var raycast: RayCast2D = $raycast

export var forgiveness_radius := 50.0

var draw_triangles := []
var draw_points := PoolVector2Array()
var draw_join_points := PoolVector2Array()
var line_points := PoolVector2Array([Vector2(),Vector2()])

var raycast_previous_cast_to := Vector2()

var raycast_previous_origin := Vector2()

func _physics_process(delta: float) -> void:
	var raycast_origin = raycast.global_position
	var raycast_previous_end = raycast_previous_cast_to + raycast.global_position
	var raycast_current_end = raycast.cast_to + raycast.global_position
	
	if raycast_previous_end!=raycast_current_end:
		draw_triangles = []
		draw_points = PoolVector2Array()
		draw_join_points = PoolVector2Array()
		
		while line_points.size()>2:
			if !check_join(raycast_previous_end, raycast_current_end):
				break
		if Input.is_action_pressed("B") and raycast_current_end.y != raycast_previous_end.y:
			print("A:",raycast_previous_end)
			print("B:",raycast_current_end)
		while true:
			
			if check_splits(raycast_origin, raycast_previous_end, raycast_current_end):
				raycast_origin = line_points[-2]
			else:
				break
	line_points[-1] = raycast.to_global(raycast.cast_to)
	raycast_previous_cast_to = raycast.cast_to
	if Input.is_action_just_pressed("A") or Input.is_key_pressed(KEY_SPACE):
	
		raycast.cast_to = raycast.to_local(get_global_mouse_position())
	
	update()
	
func check_splits(
		raycast_origin: Vector2, 
		previous_raycast_end: Vector2, 
		current_raycast_end: Vector2
	):
	draw_triangles.append(PoolVector2Array([raycast_origin,previous_raycast_end,current_raycast_end]))
	var collided_points = get_collided_points(raycast_origin, previous_raycast_end, current_raycast_end)
	if !collided_points.empty():
		if collided_points.size() == 1:
			split_at(collided_points[0])
			return true
		
		var OA = previous_raycast_end-raycast_origin
		var OB = current_raycast_end-raycast_origin
		var OAxOB = OA.cross(OB)
		
		var direction_of_spin = sign(OAxOB)
		
		var closest_point = collided_points[0]
		var closest_pseudo_angle = -1000
		
		
		for point in collided_points:

			var OP = point-raycast_origin
			
			"""
			− ||a|| ||b|| ≤ a · b ≤ ||a|| ||b|| ⇒ |a · b| ≤ ||a|| ||b||
			which means
			− 1 ≤ (a · b)/||a|| ||b|| ≤ 1
			"""
#			var pseudo_angle = (pseudoangle(OP)-pseudoangle(OA))*direction_of_spin
			var pseudo_angle = pseudoangle(OP,OA)
#			print(pseudo_angle)
			if pseudo_angle > closest_pseudo_angle:
				closest_point = point
				closest_pseudo_angle = pseudo_angle
			
		split_at(closest_point)
		return true
	return false

func check_join(
		previous_raycast_end: Vector2, 
		current_raycast_end: Vector2
	) -> bool:
	var raycast_origin = line_points[-2]
	
	if raycast_origin == raycast_previous_origin:
		join_last_two()
		return true
	
	
	if is_swing_from_side_to_side(
		raycast_previous_origin, 
		raycast_origin, 
		previous_raycast_end, 
		current_raycast_end
	):
		join_last_two()
		return true
	
	return false
	

#previous_B accounts for swings that start at exactly 0 degrees from the segment
#we need to remember what was the previous swing so that we can conclude 
#whether we are moving from A to 0 to B or from A to 0 to A back again
var previous_B := 0.0
func is_swing_from_side_to_side(Q:Vector2,O:Vector2,A:Vector2,B:Vector2):
	var QO = O - Q
	var OA = A - O
	var OB = B - O
	
	var QOxOA = QO.cross(OA)
	var QOxOB = QO.cross(OB)
	var sign_A = sign(QOxOA)
	var sign_B = sign(QOxOB)
	print("sign_B: ", sign_B)
	if sign_B == 0:
		previous_B = sign_A if sign_A else previous_B
		return false
	print("sign_A: ", sign_A)
	if sign_A == 0:
		sign_A = previous_B
	previous_B = sign_B
	return sign(sign_A)!=sign(sign_B)
	
func split_at(point:Vector2):
	print("splitting:", point)
	var global_end = raycast.cast_to+raycast.global_position
	raycast_previous_origin = raycast.global_position
	raycast.global_position = point#+raycast.global_position.direction_to(point)
	raycast.cast_to = global_end-raycast.global_position
	line_points[-1] = point
	line_points.append(global_end)
	draw_points.append(point)
	
	pass

func join_last_two():
	print("joining")
	draw_join_points.append(line_points[-2])
	line_points.remove(line_points.size()-2)
	var global_end = raycast.cast_to+raycast.global_position
	raycast_previous_origin = line_points[-3] if line_points.size()>2 else Vector2()
	var new_origin = line_points[-2] if line_points.size()>1 else Vector2()
	raycast.global_position = new_origin#+raycast.global_position.direction_to(new_origin)
	line_points[-1] = global_end
	raycast.cast_to = global_end-raycast.global_position

func get_collided_points(
		raycast_origin: Vector2,
		previous_raycast_end: Vector2,
		current_raycast_end: Vector2,
		epsilon_to_ignore = 1.0
	) -> PoolVector2Array:
	
	if !triangle_has_area(raycast_origin,previous_raycast_end,current_raycast_end):
		return PoolVector2Array()
	var query_shape := ConvexPolygonShape2D.new()
	query_shape.points = PoolVector2Array([raycast_origin,previous_raycast_end,current_raycast_end])
	var query = Physics2DShapeQueryParameters.new()
	query.collision_layer = 1
	query.shape_rid = query_shape.get_rid()
	var space = get_world_2d().direct_space_state
	var result = space.intersect_shape(query)
	var collided_points = PoolVector2Array()

	var square_epsilon = epsilon_to_ignore*epsilon_to_ignore
	
	for entry in result:
		var collider = entry.collider # The colliding object.
		var collider_id = entry.collider_id # The colliding object's ID.
		var rid = entry.rid # The intersecting object's RID.
		var shape = entry.shape # The shape index of the colliding shape.
#		print(entry)
		var shape_rid = Physics2DServer.body_get_shape(collider.get_rid(),shape)
		var shape_data = Physics2DServer.shape_get_data(shape_rid)
		var t : Transform2D = collider.global_transform*(Physics2DServer.body_get_shape_transform(collider.get_rid(),shape))
		var xformed_shape_data = t.xform(shape_data)
		if Input.is_action_pressed("C"):
			print("checking(",
				raycast_origin,", ",
				previous_raycast_end,", ",
				current_raycast_end,")")
				
		
		for point in xformed_shape_data:
			var square_dist = point.distance_squared_to(raycast_origin)
			var is_too_close_to_last_splitting_point = square_dist<square_epsilon
			
			if is_too_close_to_last_splitting_point:
				continue
#
			var is_inside = point_is_inside_triangle_inclusive(point,
				raycast_origin,
				previous_raycast_end,
				current_raycast_end)
				
#			var is_inside = Geometry.point_is_inside_triangle(point,
#					raycast_origin,
#					previous_raycast_end,
#					current_raycast_end
#				)
				
			if Input.is_action_pressed("C"):
				print("point ",point," matches:", is_inside)
				
			if !is_inside:
				continue
			
			collided_points.append(point)
	return collided_points
#	update()

func _draw() -> void:
	var i := 0
	for draw_triangle in draw_triangles:
		if !Geometry.triangulate_polygon(draw_triangle).empty():
			draw_colored_polygon(draw_triangle,Color.green.linear_interpolate(Color.cyan,i*0.5)*0.25)
		draw_triangle.append(draw_triangle[0])
		draw_polyline(draw_triangle,Color.red*0.75)
		i+=1
	
	
	var rect_size = Vector2(10,10)*$Camera2D.zoom
	var rect_offset = -rect_size*0.5
	for point in draw_points:
		draw_rect(Rect2(point+rect_offset,rect_size),Color.red)
		pass
	for point in draw_join_points:
		pass
		draw_rect(Rect2(point+rect_offset,rect_size),Color.blue)
	draw_polyline(line_points,Color.green)


func pseudoangle(vec:Vector2, vec_base: Vector2 = Vector2.RIGHT):
	return vec_base.dot(vec)/sqrt(vec_base.length_squared()*vec.length_squared())
#	return 1.0 - vec.x/(abs(vec.x)+abs(vec.y))*sign(vec.y) if vec else 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("B"):
		print(line_points)
	if event.is_action_pressed("ui_left",true):
		raycast.cast_to = raycast.cast_to+Vector2.LEFT
	if event.is_action_pressed("ui_right",true):
		raycast.cast_to = raycast.cast_to+Vector2.RIGHT
	if event.is_action_pressed("ui_up",true):
		raycast.cast_to = raycast.cast_to+Vector2.UP
	if event.is_action_pressed("ui_down",true):
		raycast.cast_to = raycast.cast_to+Vector2.DOWN


func point_is_inside_triangle_inclusive(p:Vector2,a:Vector2,b:Vector2,c:Vector2):
#	debugging block

	
	var result = (
		(p == a or p == b or p == c) or
		(triangle_has_area(a,b,c) and Geometry.point_is_inside_triangle(p,a,b,c)) or
		Geometry.get_closest_point_to_segment_2d(p,a,b) == p or
		Geometry.get_closest_point_to_segment_2d(p,b,c) == p or
		Geometry.get_closest_point_to_segment_2d(p,c,a) == p
		
	)
	
	if result:
		print ("p == a or p == b or p == c :", p == a or p == b or p == c)
		print("triangle_has_area(a,b,c) : ", triangle_has_area(a,b,c))
		print("Geometry.point_is_inside_triangle(p,a,b,c) : ",Geometry.point_is_inside_triangle(p,a,b,c))
		print("Geometry.get_closest_point_to_segment_2d(p,a,b) == p : ", Geometry.get_closest_point_to_segment_2d(p,a,b) == p)
		print("Geometry.get_closest_point_to_segment_2d(p,b,c) == p : ", Geometry.get_closest_point_to_segment_2d(p,b,c) == p)
		print("Geometry.get_closest_point_to_segment_2d(p,c,a) == p : ", Geometry.get_closest_point_to_segment_2d(p,c,a) == p)

	return result
func _ready() -> void:
	raycast.global_position = line_points[-2]
	raycast.cast_to = raycast.to_local(line_points[-1])
	raycast_previous_cast_to = raycast.cast_to
	raycast_previous_origin = line_points[-3] if line_points.size()>=3 else line_points[-2]

func triangle_has_area(a:Vector2,b:Vector2,c:Vector2)->bool:
#	print("Geometry.get_closest_point_to_segment_uncapped_2d(a,b,c) :", Geometry.get_closest_point_to_segment_uncapped_2d(a,b,c))
#	print("a : ", a)
	return !Geometry.get_closest_point_to_segment_uncapped_2d(a,b,c).is_equal_approx(a)
