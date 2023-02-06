extends CharacterState


func _physics_update(delta):
	
#	if !root.is_on_floor():
#		if root.input_state.A.is_just_pressed():
#			root.velocity.y -= root.jump_speed
#			goto("air")
##			print("precoyote_jump")
#			return
#		goto_args("air",["coyote"])
#		return
#
#	if root.input_state.A.is_just_pressed():
#		root.velocity.y -= root.jump_speed
#		goto("air")
#
#		return
	
	
	
	var input_dir : Vector2 = root.input_state.dir
	
	var rotated_input_dir = input_dir.rotated(-root.pivot.rotation)
	if !is_equal_approx(rotated_input_dir.x,0):
		print(rotated_input_dir.x)
		root.facing_dir = rotated_input_dir.x
		goto("walk")
		return
	
	root.velocity.x = 0
	
