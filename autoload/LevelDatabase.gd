extends Node

@export var levels: Dictionary = {}

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
