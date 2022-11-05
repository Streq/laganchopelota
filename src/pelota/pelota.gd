extends KinematicBody2D

onready var input_state := $input_state

export var linear_velocity := Vector2()
export var gravity := 9.8


func _physics_process(delta: float) -> void:
	linear_velocity.y += delta*gravity*25.0
	linear_velocity = move_and_slide(linear_velocity)

func apply_central_impulse(impulse):
	linear_velocity += impulse
