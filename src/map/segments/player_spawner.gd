extends Node2D

onready var controller: Node = $controller
onready var player_zone: Area2D = $player_zone
onready var camera_2d: Camera2D = $Camera2D
export var PELOTA : PackedScene

func _on_segment_init() -> void:
	var pelota = PELOTA.instance()
	owner.owner.add_child(pelota)
	pelota.global_position = global_position
	NodeUtils.reparent(controller, pelota)
	NodeUtils.reparent(player_zone, pelota)
	NodeUtils.reparent(camera_2d, pelota)
	
	
