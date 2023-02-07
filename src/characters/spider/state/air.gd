extends CharacterState


func _physics_update(delta):
	var input_dir : Vector2 = root.input_state.dir
	var rotated_input_dir = input_dir.rotated(-root.pivot.rotation)
	
	if !is_equal_approx(rotated_input_dir.x,0):
		print(rotated_input_dir.x)
		root.facing_dir = rotated_input_dir.x
		goto("walk")
		return
	
	root.velocity.x = 0
	
