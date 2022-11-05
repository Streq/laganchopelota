extends State

#OVERRIDABLE

# Initialize the state. E.g. change the animation
func _enter(params):
	root.hide()
	call_deferred("reparent_to_wearer")
func reparent_to_wearer():
	#claw reparented to us
	NodeUtils.reparent(root, root.wearer)
	root.position = Vector2()

# Clean up the state. Reinitialize values like a timer
func _exit():
	root.show()
	
# Called during _physics_process
func _physics_update(delta: float):
	if owner.wearer.input_state.A.is_just_pressed():
		goto("throw")
