extends State

#OVERRIDABLE

# Initialize the state. E.g. change the animation
func _enter(params):
	root.animation_player.play(name)
#	root.hide()
	call_deferred("reparent_to_wearer")
func reparent_to_wearer():
	#claw reparented to us
	NodeUtils.reparent(root, root.wearer)
	root.position = Vector2()

# Clean up the state. Reinitialize values like a timer
func _exit():
#	root.show()
	pass
# Called during _physics_process
var dir = Vector2.RIGHT
func _physics_update(delta: float):
	var wearer = root.wearer
	var input_dir = root.wearer.input_state.dir
	if input_dir:
		dir = input_dir.normalized()
	root.global_position = wearer.global_position+dir*16.0
	root.global_rotation = dir.angle()
	
	if owner.wearer.input_state.A.is_just_pressed():
		goto_args("throw",[dir])
