extends Node

var definitions: Dictionary = {}

func _ready():
	var folder = DirAccess.open("res://data/nodes/")
	for file in folder.get_files():
		print('ndb', file)
		if file.ends_with(".tres"):
			var def = load("res://data/nodes/" + file)
			register_node(def)
			
func reset():
	definitions  = {}
	var folder = DirAccess.open("res://data/nodes/")
	for file in folder.get_files():
		print('ndb', file)
		if file.ends_with(".tres"):
			var def = load("res://data/nodes/" + file)
			register_node(def)

func register_node(def: NodeDefinition):
	definitions[def.id] = def

func get_definition(id: String) -> NodeDefinition:
	return definitions.get(id)
