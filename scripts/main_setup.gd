extends Control
@onready var studio_scene = preload("res://scenes/studio.tscn")

func _on_timer_2_timeout() -> void:
	var studio  = studio_scene.instantiate()
	self.add_child(studio)
	print('shown hsplit')
