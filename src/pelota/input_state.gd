extends Node


var A := ButtonState.new()
var B := ButtonState.new()
var dir := Vector2() setget set_dir

func set_dir(val:Vector2):
	dir = val.limit_length()

func _physics_process(delta: float) -> void:
	A.stale()
	B.stale()
