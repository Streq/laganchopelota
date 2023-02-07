extends CharacterState
onready var no_more_floor_detect: RayCast2D = $"%no_more_floor_detect"
onready var corner_detect: RayCast2D = $"%corner_detect"

func _physics_update(delta):
	root.velocity.x = 0
	var input_dir : Vector2 = root.input_state.dir
	
	
	var rotated_input_dir = input_dir.rotated(-root.pivot.rotation)
	if is_equal_approx(rotated_input_dir.x,0.0):
		goto("idle")
		return
	
	
	root.facing_dir = rotated_input_dir.x
	pass

func advance(step_size := 1.0):
	var r :KinematicBody2D = root
	var collision = r.move_and_collide(Vector2(root.facing_dir*step_size, 0.0).rotated(root.pivot.rotation))
	if collision:
		print(collision)
#		root.pivot.rotation = Vector2(root.facing_dir,0)
		print(collision.normal)
		root.pivot.rotation = PI/2 + collision.normal.angle()
		goto("corner_concave")
		return
	else:
		no_more_floor_detect.force_raycast_update()
		if !no_more_floor_detect.is_colliding():
			corner_detect.force_raycast_update()
			if corner_detect.is_colliding():
				root.pivot.rotation = PI/2 + corner_detect.get_collision_normal().angle()
				root.global_position = corner_detect.get_collision_point()-Vector2.DOWN.rotated(root.pivot.rotation)*4
				goto("corner")
				return
