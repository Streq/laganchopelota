extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	print(Geometry.line_intersects_line_2d(Vector2(0,0),Vector2(1,0), Vector2(2,0), Vector2(2,0)))
#	print(Geometry.segment_intersects_segment_2d(Vector2(0,0),Vector2(2,0), Vector2(0,0), Vector2(2,0)))
#	var a = [1,2,3]
#	a.insert(a.size()-1,4)
#	print(a)
#	var r = PoolRealArray([1,2,3])
#	r.insert(0,4)
#	print(r)
	var array = []
	append_something(array,"hola")
	print(array)



func append_something(array, something):
	array.append(something)
