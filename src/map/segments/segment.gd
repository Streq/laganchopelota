extends Node2D

onready var gap: Node2D = $gap
export var height := 270.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gap.position.x += stepify(rand_range(-320,320),16.0)
