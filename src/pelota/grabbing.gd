extends State

func _enter(params):
	var grabbed = params[0]
	call_deferred("reparent_to_grabbed",grabbed)
	root.velocity = Vector2()

func reparent_to_grabbed(grabbed):
	NodeUtils.reparent_keep_transform(root, grabbed)
	

# Clean up the state. Reinitialize values like a timer
func _exit():
	return
	
# Called during _physics_process
func _physics_update(delta: float):
	if !root.wearer.input_state.A.is_pressed():
		goto("retrieving")
		return
	root.wearer.apply_central_impulse(root.wearer.global_position.direction_to(root.global_position)*root.pull_force*delta)
