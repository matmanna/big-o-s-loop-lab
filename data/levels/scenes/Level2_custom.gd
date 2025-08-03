extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_node('../').vars)
	get_node('../Goal').position.y = get_node('../').vars["goal_y"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
