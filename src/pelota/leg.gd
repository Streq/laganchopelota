extends Node2D
onready var air_jump_cooldown: Timer = $air_jump_cooldown

export var jump_speed := 250.0
var dir = Vector2.RIGHT
func _physics_process(delta: float) -> void:
	var input = owner.input_state
	if input.dir:
		dir = input.dir
	global_rotation_degrees = -90
	
#	if input.B.is_just_pressed() and owner.is_on_wall():
#		owner.jump_against_walls()
	if input.B.is_just_pressed() and air_jump_cooldown.is_stopped():
		owner.jump_in_dir()
		air_jump_cooldown.start()
