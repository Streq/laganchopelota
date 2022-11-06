extends TextureProgress

export (NodePath) onready var timer = get_node(timer) as Timer
onready var full_bar_marker: MarginContainer = $full_bar_marker

func _physics_process(delta: float) -> void:
	ratio = 1.0-timer.time_left/timer.wait_time
	full_bar_marker.visible = ratio>=1.0
