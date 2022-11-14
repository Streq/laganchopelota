extends Node2D

onready var line: Line2D = $line
onready var raycast: RayCast2D = $raycast

var current_unwrapped_ray_index = 0
export var forgiveness_radius := 50.0

var draw_triangle := PoolVector2Array()
var draw_points := PoolVector2Array()

var line_points := PoolVector2Array([Vector2(),Vector2()])

var raycast_previous_cast_to := Vector2()

func _physics_process(delta: float) -> void:
	draw_points = PoolVector2Array()
	
	var raycast_origin = raycast.global_position
	var raycast_previous_end = raycast_previous_cast_to + raycast.global_position
	var raycast_current_end = raycast.cast_to + raycast.global_position
	
	draw_triangle = PoolVector2Array([raycast.global_position, raycast_previous_end, raycast_current_end])
	
#	if raycast.is_colliding():
	check_splits(raycast_origin, raycast_previous_end, raycast_current_end)
	line_points[-1] = raycast.to_global(raycast.cast_to)
	raycast_previous_cast_to = raycast.cast_to
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
#		if collided_points.size() == 1:
#			split_at(collided_points[0])
#		else:
			var OA = previous_raycast_end-raycast_origin
			var OB = current_raycast_end-raycast_origin
			var OAxOB = OA.cross(OB)
			
			var direction_of_spin = sign(OAxOB)
			
			var closest_point = collided_points[0]
			var closest_pseudo_angle = 1000
			
			collided_points.sort()
			for point in collided_points:

				var OP = point-raycast_origin
				
				var pseudo_angle = (pseudoangle(OP)-pseudoangle(OA))*direction_of_spin
				
				
				if pseudo_angle < closest_pseudo_angle:
					closest_point = point
					closest_pseudo_angle = pseudo_angle
				
			split_at(closest_point)
				
			
func split_at(point:Vector2):
	var global_end = raycast.cast_to+raycast.global_position
	raycast.global_position = point+raycast.global_position.direction_to(point)
	raycast.cast_to = global_end-raycast.global_position
	line_points[-1] = point
	line_points.append(global_end)
	pass

func get_collided_points(
		raycast_origin: Vector2,
		previous_raycast_end: Vector2,
		current_raycast_end: Vector2
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
		
		
		for point in xformed_shape_data:
			if Geometry.point_is_inside_triangle(
				point,
				raycast_origin,
				previous_raycast_end,
				current_raycast_end
			):
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
	return 1.0 - vec.x/(abs(vec.x)+abs(vec.y))*sign(vec.y)
