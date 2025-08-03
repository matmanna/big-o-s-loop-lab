extends Node

var levels: Dictionary = {}

func _ready():
	var folder = DirAccess.open("res://data/levels/")
	for file in folder.get_files():
		if file.ends_with(".tres"):
			var def = load("res://data/levels/" + file)
			register_level(def)

func register_level(lev: LevelData):
	levels[lev.name] = lev

func get_level(name: String) -> LevelData:
	return levels.get(name)
