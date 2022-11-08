extends TileMap


func _ready() -> void:
	yield(owner,"ready")
	get_tree().call_group("tilemap_fill","fill_tilemap",self,0)
	
	update_bitmask_region()
