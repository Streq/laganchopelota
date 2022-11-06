extends Node2D

onready var links: Node2D = $links

func _process(delta: float) -> void:
	var i = 0
	var size = links.get_child_count()
	
	var start_pos = owner.global_position
	var end_pos = owner.wearer.global_position
	var distance_vector = end_pos-start_pos

	for child in links.get_children():
		child.global_position = start_pos+(distance_vector/size)*i
		child.global_rotation = 0
		i+=1
