extends Node2D

onready var rope = get_parent()

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		rope.step(get_global_mouse_position())

	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left",true):
		rope.step(rope.line_points[0],rope.line_points[-1]+Vector2.LEFT)
	if event.is_action_pressed("ui_right",true):
		rope.step(rope.line_points[0],rope.line_points[-1]+Vector2.RIGHT)
	if event.is_action_pressed("ui_up",true):
		rope.step(rope.line_points[0],rope.line_points[-1]+Vector2.UP)
	if event.is_action_pressed("ui_down",true):
		rope.step(rope.line_points[0],rope.line_points[-1]+Vector2.DOWN)
