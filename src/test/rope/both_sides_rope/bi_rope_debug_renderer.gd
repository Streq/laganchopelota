extends Node2D

export var camera_path : NodePath
onready var camera : Camera2D = get_node(camera_path) if has_node(camera_path) else null

var check_triangles = []
var split_points = []
var join_points = []
var scanned_points = []
var rope_points = PoolVector2Array()

func _on_bi_rope_check(O, A, B) -> void:
	check_triangles.append(PoolVector2Array([O,A,B]))

func _on_bi_rope_join(point) -> void:
	join_points.append(point)


func _on_bi_rope_scanned_points(points) -> void:
	scanned_points.append(points)

func _on_bi_rope_split(point) -> void:
	split_points.append(point)

func _on_bi_rope_step_begin() -> void:
	check_triangles = []
	split_points = []
	join_points = []
	scanned_points = []

func _on_bi_rope_step_end() -> void:
	pass # Replace with function body.
	
	
func _process(delta: float) -> void:
	update()

func _draw() -> void:
	for draw_triangle in check_triangles:
		draw_triangle.append(draw_triangle[0])
		if !Geometry.triangulate_polygon(draw_triangle).empty():
			draw_colored_polygon(draw_triangle,Color.yellow*0.1)
		draw_polyline(draw_triangle,Color.yellow*0.75)

#	var i := 0
#	for draw_triangle in draw_triangles:
#		if !Geometry.triangulate_polygon(draw_triangle).empty():
#			draw_colored_polygon(draw_triangle,Color.green.linear_interpolate(Color.cyan,i*0.5)*0.25)
#		draw_triangle.append(draw_triangle[0])
#		draw_polyline(draw_triangle,Color.red*0.75)
#		i+=1
	
	var zoom = camera.zoom
	var rect_size = Vector2(10,10)*zoom
	var rect_offset = -rect_size*0.5
	for point in split_points:
		draw_rect(Rect2(point+rect_offset,rect_size),Color(1.0,0.0,0.0,0.5))
	for point in join_points:
		draw_rect(Rect2(point+rect_offset,rect_size),Color(0.0,0.0,1.0,0.5))
		
	draw_polyline(rope_points,Color.green)
	pass


func _on_bi_rope_updated(points) -> void:
	rope_points = points
