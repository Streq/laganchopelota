extends CharacterState

func _enter(params):
	
	root.pivot.rotation = PI/2 + params[0].normal.angle()
#	r.move_and_collide(Vector2.DOWN.rotated(root.pivot.rotation)*6)
#	r.move_and_collide(Vector2.LEFT.rotated(root.pivot.rotation)*root.facing_dir*6)

func _physics_update(delta):
#	if root.animation_player.is_playing():
#		return
	var input_dir : Vector2 = root.input_state.dir
	
	var rotated_input_dir = input_dir.rotated(-root.pivot.rotation)

	if !is_equal_approx(rotated_input_dir.x,0):
		print(rotated_input_dir)
		root.facing_dir = rotated_input_dir.x
		goto("walk")
		return
	if !is_equal_approx(rotated_input_dir.y,0) and rotated_input_dir.y < 0:
		root.facing_dir = rotated_input_dir.y*root.facing_dir
		goto("walk")
		return
	root.velocity.x = 0
	
