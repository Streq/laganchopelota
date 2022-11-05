extends Node


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_pressed():
		match event.scancode:
			KEY_R:
				if OS.is_debug_build():
					get_tree().reload_current_scene()
			KEY_F:
				OS.window_fullscreen = !OS.window_fullscreen
		
