extends Node2D
tool
onready var _0: Position2D = $"0"
onready var _1: Position2D = $"1"


func _draw() -> void:
	draw_line(_0.position,_1.position,Color.blue,1.0)
	
	
func _process(delta: float) -> void:
	update()
