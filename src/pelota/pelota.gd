
#onready var input_state := $input_state

#export var linear_velocity := Vector2()
#export var gravity := 9.8
#
#export var jump_speed := 250.0
#
#func _physics_process(delta: float) -> void:
#	linear_velocity.y += delta*gravity*25.0
#	linear_velocity = move_and_slide(linear_velocity)
#
#func apply_central_impulse(impulse):
#	linear_velocity += impulse
#func jump_against_walls():
#	var collision_count = get_slide_count()
#	for i in collision_count:
#		var collision : KinematicCollision2D = owner.get_slide_collision(i)
#		apply_central_impulse(collision.normal*jump_speed)
#		return
extends RigidBody2D
onready var input_state := $input_state
onready var animation_player: AnimationPlayer = $AnimationPlayer

export var jump_speed := 250.0

func is_on_wall():
	return get_colliding_bodies().size()>0

var jump_against_walls = false
func jump_against_walls():
	jump_against_walls = true
	animation_player.play("jump")
	pass

var jump_in_dir = false
func jump_in_dir():
	jump_in_dir = true
	animation_player.play("jump")
	pass


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if jump_against_walls:
		var normal = Vector2()
		for contact in state.get_contact_count():
			var local_normal = state.get_contact_local_normal(contact)
			normal+=local_normal
		apply_central_impulse(normal.normalized()*jump_speed)
	if jump_in_dir:
		var dir = input_state.dir
		apply_central_impulse(dir.normalized()*jump_speed)
	jump_against_walls = false
	jump_in_dir = false
