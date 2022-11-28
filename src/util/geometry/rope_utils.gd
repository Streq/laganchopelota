extends Node
class_name RopeUtils

static func get_side_of_swing(Q:Vector2,O:Vector2,A:Vector2):
	var QO = O - Q
	var OA = A - O
	var QOxOA = QO.cross(OA)
	
	return sign(QOxOA)

static func is_swing_from_side_to_middle(Q:Vector2,O:Vector2,A:Vector2,B:Vector2):
	var QO = O - Q
	var OA = A - O
	var OB = B - O
	
	var QOxOA = QO.cross(OA)
	var QOxOB = QO.cross(OB)
	var sign_A = sign(QOxOA)
	var sign_B = sign(QOxOB)

	
	return sign_A != 0 and sign_B == 0
static func is_swing_from_middle_to_side(Q:Vector2,O:Vector2,A:Vector2,B:Vector2):
	var QO = O - Q
	var OA = A - O
	var OB = B - O
	
	var QOxOA = QO.cross(OA)
	var QOxOB = QO.cross(OB)
	var sign_A = sign(QOxOA)
	var sign_B = sign(QOxOB)

	
	return sign_A == 0 and sign_B != 0
static func get_side_of_full_swing(Q:Vector2,O:Vector2,A:Vector2,B:Vector2):
	var QO = O - Q
	var OA = A - O
	var OB = B - O
	
	var QOxOA = QO.cross(OA)
	var QOxOB = QO.cross(OB)
	var sign_A = sign(QOxOA)
	var sign_B = sign(QOxOB)

	if sign_A == sign_B:
		return sign_A
	if sign_B == 0:
		return -sign_A
	return sign_B
	
static func get_current_side_of_swing(Q:Vector2, O:Vector2, P:Vector2):
	return sign((O-Q).cross(P-O))
	
	
static func pseudoangle(vec:Vector2, vec_base: Vector2 = Vector2.RIGHT):
	return vec_base.dot(vec)/sqrt(vec_base.length_squared()*vec.length_squared())
#	return 1.0 - vec.x/(abs(vec.x)+abs(vec.y))*sign(vec.y) if vec else 0.0




static func point_is_inside_triangle_inclusive(p:Vector2,a:Vector2,b:Vector2,c:Vector2):
	var result = (
		(p == a or p == b or p == c) or
		(triangle_has_area(a,b,c) and Geometry.point_is_inside_triangle(p,a,b,c)) or
		Geometry.get_closest_point_to_segment_2d(p,a,b) == p or
		Geometry.get_closest_point_to_segment_2d(p,b,c) == p or
		Geometry.get_closest_point_to_segment_2d(p,c,a) == p
	)

#	if result:
#		print ("p == a or p == b or p == c :", p == a or p == b or p == c)
#		print("triangle_has_area(a,b,c) : ", triangle_has_area(a,b,c))
#		print("Geometry.point_is_inside_triangle(p,a,b,c) : ",Geometry.point_is_inside_triangle(p,a,b,c))
#		print("Geometry.get_closest_point_to_segment_2d(p,a,b) == p : ", Geometry.get_closest_point_to_segment_2d(p,a,b) == p)
#		print("Geometry.get_closest_point_to_segment_2d(p,b,c) == p : ", Geometry.get_closest_point_to_segment_2d(p,b,c) == p)
#		print("Geometry.get_closest_point_to_segment_2d(p,c,a) == p : ", Geometry.get_closest_point_to_segment_2d(p,c,a) == p)

	return result

static func point_is_inside_triangle_inclusive_but_exclude_first_segment(p:Vector2,a:Vector2,b:Vector2,c:Vector2):
	var result = (
		(p == c) or
		(triangle_has_area(a,b,c) and Geometry.point_is_inside_triangle(p,a,b,c)) or
		Geometry.get_closest_point_to_segment_2d(p,b,c) == p or
		Geometry.get_closest_point_to_segment_2d(p,c,a) == p
	)
#
#	if result:
#		print ("p == c :", p == c)
#		print("triangle_has_area(a,b,c) : ", triangle_has_area(a,b,c))
#		print("Geometry.point_is_inside_triangle(p,a,b,c) : ",Geometry.point_is_inside_triangle(p,a,b,c))
#		print("Geometry.get_closest_point_to_segment_2d(p,b,c) == p : ", Geometry.get_closest_point_to_segment_2d(p,b,c) == p)
#		print("Geometry.get_closest_point_to_segment_2d(p,c,a) == p : ", Geometry.get_closest_point_to_segment_2d(p,c,a) == p)

	return result

static func triangle_has_area(a:Vector2,b:Vector2,c:Vector2)->bool:
#	print("Geometry.get_closest_point_to_segment_uncapped_2d(a,b,c) :", Geometry.get_closest_point_to_segment_uncapped_2d(a,b,c))
#	print("a : ", a)
#	return Geometry.triangulate_polygon(PoolVector2Array([a,b,c]))
#	return true
#	print("closest_point_uncapped:",Geometry.get_closest_point_to_segment_uncapped_2d(a,b,c))
#	print("a:",a)
	
	return Geometry.get_closest_point_to_segment_uncapped_2d(a,b,c) != a
