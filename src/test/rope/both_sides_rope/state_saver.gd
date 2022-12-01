extends Node2D

export var camera_path : NodePath
export var rope_path : NodePath

onready var camera :Camera2D = get_node(camera_path)
onready var rope :Node2D = get_node(rope_path)
