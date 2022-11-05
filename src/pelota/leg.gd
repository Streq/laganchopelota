extends Node2D
onready var wall_detect: Area2D = $wall_detect

export var jump_speed := 250.0
var dir = Vector2.RIGHT
func _physics_process(delta: float) -> void:
	var input = owner.input_state
	if input.dir:
		dir = input.dir
	global_rotation = dir.angle()
	
	if input.B.is_just_pressed() and owner.is_on_wall():
		var collision_count = owner.get_slide_count()
		for i in collision_count:
			var collision : KinematicCollision2D = owner.get_slide_collision(i)
			owner.apply_central_impulse(collision.normal*jump_speed)
			return
