extends Node

var definitions: Dictionary = {}

func _ready():
	reset()
			
func reset():
	definitions  = {}
	var folder = DirAccess.open("res://data/nodes/")
	for file in folder.get_files():
		print('ndb', file)
		if file.ends_with(".tres") or file.ends_with(".tres.remap"):
			var def = ResourceLoader.load("res://data/nodes/" +  file.replace(".remap", ""))
			register_node(def)

func register_node(def: NodeDefinition):
	definitions[def.id] = def

func get_definition(id: String) -> NodeDefinition:
	return definitions.get(id)
