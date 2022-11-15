extends Node2D

onready var line: Line2D = $line
onready var raycast: RayCast2D = $raycast

var current_unwrapped_ray_index = 0
export var forgiveness_radius := 50.0

var draw_triangle := PoolVector2Array()
var draw_points := PoolVector2Array()
var line_points := PoolVector2Array([Vector2(),Vector2()])

var raycast_previous_cast_to := Vector2()

var raycast_previous_origin := Vector2()

func _physics_process(delta: float) -> void:
	draw_points = PoolVector2Array()
	
	var raycast_origin = raycast.global_position
	var raycast_previous_end = raycast_previous_cast_to + raycast.global_position
	var raycast_current_end = raycast.cast_to + raycast.global_position
	
	draw_triangle = PoolVector2Array([raycast.global_position, raycast_previous_end, raycast_current_end])
	
	while line_points.size()>2:
		if !check_join(raycast_previous_end, raycast_current_end):
			break
	if raycast_previous_end!=raycast_current_end:
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
	if Input.is_action_just_pressed("A"):
		raycast.cast_to = raycast.to_local(get_global_mouse_position())
	
	update()
	
func check_splits(
		raycast_origin: Vector2, 
		previous_raycast_end: Vector2, 
		current_raycast_end: Vector2
	):
	draw_triangle = PoolVector2Array([raycast_origin,previous_raycast_end,current_raycast_end])
	
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
		var closest_pseudo_angle = 1000
		
		for point in collided_points:

			var OP = point-raycast_origin
			
			var pseudo_angle = (pseudoangle(OP)-pseudoangle(OA))*direction_of_spin
			if pseudo_angle < closest_pseudo_angle:
				closest_point = point
				closest_pseudo_angle = pseudo_angle
			
		split_at(closest_point)
		return true
	return false

func check_join(
		previous_raycast_end: Vector2, 
		current_raycast_end: Vector2
	)->bool:
	var raycast_origin = line_points[-2]
	
	var join = (
		(raycast_origin == raycast_previous_origin) 
		or 
		is_swing_from_side_to_side(
			raycast_previous_origin, 
			raycast_origin, 
			previous_raycast_end, 
			current_raycast_end
		)
	)
	if join:
		join_last_two()
	return join


#prev_B accounts for swings that start at exactly 0 degrees from the segment
#we need to remember what was the previous swing so that we can conclude 
#whether we are moving from A to 0 to B or from A to 0 to A back again
var prev_B := 0.0
func is_swing_from_side_to_side(Q:Vector2,O:Vector2,A:Vector2,B:Vector2):
	var QO = O - Q
	var OA = A - O
	var OB = B - O
	
	var QOxOA = QO.cross(OA)
	var QOxOB = QO.cross(OB)
	var sign_A = sign(QOxOA)
	var sign_B = sign(QOxOB)
	if sign_B == 0:
		print("sign_B", sign_B)
		prev_B = sign_A if sign_A else prev_B
		return false
	if sign_A == 0:
		print("sign_A", sign_A)
		sign_A = prev_B
	return sign(sign_A)!=sign(sign_B)
	
func split_at(point:Vector2):
	print("splitting:", point)
	var global_end = raycast.cast_to+raycast.global_position
	raycast_previous_origin = raycast.global_position
	raycast.global_position = point#+raycast.global_position.direction_to(point)
	raycast.cast_to = global_end-raycast.global_position
	line_points[-1] = point
	line_points.append(global_end)
	pass

func join_last_two():
	print("joining")
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
	var query_shape := ConvexPolygonShape2D.new()
	query_shape.points = draw_triangle
	var query = Physics2DShapeQueryParameters.new()
	query.collision_layer = 1
	query.shape_rid = query_shape.get_rid()
	var space = get_world_2d().direct_space_state
	var result = space.intersect_shape(query)
	var collided_points = PoolVector2Array()

	
	for entry in result:
		var collider = entry.collider # The colliding object.
		var collider_id = entry.collider_id # The colliding object's ID.
		var rid = entry.rid # The intersecting object's RID.
		var shape = entry.shape # The shape index of the colliding shape.
#		print(entry)
		var shape_rid = Physics2DServer.body_get_shape(collider.get_rid(),shape)
		var shape_data = Physics2DServer.shape_get_data(shape_rid)
		var t : Transform2D = collider.global_transform
		var xformed_shape_data = t.xform(shape_data)
		if Input.is_action_pressed("C"):
			print("checking(",
				raycast_origin,", ",
				previous_raycast_end,", ",
				current_raycast_end,")")
				
		
		for point in xformed_shape_data:
			var is_inside = point_is_inside_triangle_inclusive(point,
		raycast_origin,
		previous_raycast_end,
		current_raycast_end)
			if Input.is_action_pressed("C"):
				print("point ",point," matches:", is_inside)
			if is_inside and point.distance_squared_to(raycast_origin)>epsilon_to_ignore*epsilon_to_ignore:
				collided_points.append(point)
	return collided_points
#	update()

func _draw() -> void:
	if draw_triangle:
		draw_colored_polygon(draw_triangle,Color.rebeccapurple)
	for point in draw_points:
		draw_rect(Rect2(point-Vector2(5,5),Vector2(10,10)),Color.red)
	draw_polyline(line_points,Color.green)


func pseudoangle(vec:Vector2):
	return 1.0 - vec.x/(abs(vec.x)+abs(vec.y))*sign(vec.y) if vec else 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("B"):
		print(line_points)


func point_is_inside_triangle_inclusive(p:Vector2,a:Vector2,b:Vector2,c:Vector2):
	return (
		(p == a or p == b or p == c) or
		Geometry.point_is_inside_triangle(p,a,b,c) or
		Geometry.get_closest_point_to_segment_2d(p,a,b).is_equal_approx(p) or
		Geometry.get_closest_point_to_segment_2d(p,b,c).is_equal_approx(p) or
		Geometry.get_closest_point_to_segment_2d(p,c,a).is_equal_approx(p)
		
	)
	
