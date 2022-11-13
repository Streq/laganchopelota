extends Node2D

onready var rays = $rays.get_children()
onready var line: Line2D = $Line2D

var current_unwrapped_ray_index = 0
export var forgiveness_radius := 50.0


func _ready() -> void:
	line.points.resize(rays.size())

func _physics_process(delta: float) -> void:
	var points = []
	
	
	var ray :RayCast2D = rays[current_unwrapped_ray_index]
	
	if ray.is_colliding():
		var collision_point = ray.get_collision_point()
		var distance_to_last_point_squared = (ray.global_position - collision_point).length_squared()
		
		if distance_to_last_point_squared>forgiveness_radius*forgiveness_radius:
			current_unwrapped_ray_index = min(current_unwrapped_ray_index+1,rays.size()-1)
			rays[current_unwrapped_ray_index].position = collision_point
		else:
			ray.add_exception(ray.get_collider())
			get_world_2d().direct_space_state.intersect_ray
	for i in current_unwrapped_ray_index:
		rays[i].enabled = false
		points.append(rays[i].position)
	for i in range(current_unwrapped_ray_index+1, rays.size()):
		rays[i].enabled = false
		
	ray = rays[current_unwrapped_ray_index]
	points.append(ray.position)
	points.append(ray.position+ray.cast_to)
	
	line.points = PoolVector2Array(points)
	
	ray.cast_to = ray.to_local(get_global_mouse_position())
	ray.enabled = true
	
	print(current_unwrapped_ray_index)
	
	
