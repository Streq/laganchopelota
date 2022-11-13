extends Node2D

onready var line: Line2D = $Line2D

var current_unwrapped_ray_index = 0
export var forgiveness_radius := 50.0

func _physics_process(delta: float) -> void:
#	Geometry.get_closest_points_between_segments_2d()
	pass
