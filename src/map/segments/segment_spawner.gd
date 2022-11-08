extends Node2D

export (Array, Array, PackedScene) var segments


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var accumulated_height = 0
	
	for i in 1:
		var segment = segments[0][randi()%segments[0].size()].instance()
		add_child(segment)
		accumulated_height -= segment.height
		segment.position.y = accumulated_height
	
	for difficulty in range(1,segments.size()):
		for i in 6:
			var segment = segments[difficulty][randi()%segments[difficulty].size()].instance()
			add_child(segment)
			accumulated_height -= segment.height
			segment.position.y = stepify(accumulated_height,16)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
