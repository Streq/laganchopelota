extends Camera2D

var zoom_factor = 0.0
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event :InputEventMouseButton = event
		if mouse_event.button_index == BUTTON_WHEEL_UP:
			zoom_factor -= 1
			zoom_at_point(mouse_event.position)
			
		if mouse_event.button_index == BUTTON_WHEEL_DOWN:
			zoom_factor += 1
			zoom_at_point(mouse_event.position)
	
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		var mouse_motion : InputEventMouseMotion = event
		position -= mouse_motion.relative*zoom
func _physics_process(delta: float) -> void:
	self.anchor_mode


func zoom_at_point(point):
	var c0 = global_position # camera position
	var v0 = get_viewport().size # vieport size
	var c1 # next camera position
	var z0 = zoom # current zoom value
	var z1 = Vector2(1,1)*pow(1.1,zoom_factor) # next zoom value

	c1 = c0 + (-0.5*v0 + point)*(z0 - z1)
	zoom = z1
	global_position = c1
