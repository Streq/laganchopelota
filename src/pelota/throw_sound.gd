extends AudioStreamPlayer2D

func _physics_process(delta: float) -> void:
	var relative_velocity = owner.velocity-owner.wearer.linear_velocity
	var speed = relative_velocity.length()
	self.pitch_scale = speed/200.0
	self.volume_db = clamp((-800+speed)/10.0,-80,0)
#	print (speed)
	
func play(from_position:float = 0.0):
	if !playing:
		.play(from_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
