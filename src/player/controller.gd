extends Node


func _unhandled_input(event: InputEvent) -> void:
	var state = get_parent().input_state
	if event.is_action("A"):
		state.A.pressed = event.is_pressed()
	if event.is_action("B"):
		state.B.pressed = event.is_pressed()
		
func _physics_process(delta: float) -> void:
	get_parent().input_state.dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
