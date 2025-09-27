extends Node

@export var levels: Dictionary = {}
@onready var studio_scene = preload("res://scenes/studio.tscn")

func _ready():
	reset()
	
func reset():
	var folder = DirAccess.open("res://data/levels/")
	for file in folder.get_files():
		print('hey', file)
		if file.ends_with(".tres") or  file.ends_with(".tres.remap"):
			var def = ResourceLoader.load("res://data/levels/" +  file.replace(".remap", ""))
			register_level(def)
	print('levels', levels)

func register_level(lev: LevelData):
	levels[lev.name] = lev

func get_level(name: String) -> LevelData:
	#print('hi')
	#print(levels, name)
	return levels.get(name)


func _on_timer_2_timeout() -> void:
	var studio  = studio_scene.instantiate()
	get_node('../').add_child(studio)
	print('shown hsplit')
