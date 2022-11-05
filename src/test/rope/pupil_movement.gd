extends Node2D

onready var eye_pupil: Sprite = $eye_pupil

func _physics_process(delta: float) -> void:
	var dir = owner.input_state.dir
	eye_pupil.position = dir*4
