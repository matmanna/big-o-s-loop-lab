extends Line2D
class_name WireLine2D

var from_node: LogicNode
var from_port: String
var to_node: LogicNode
@export var preview:=false
var to_port: String

func _ready():
	if from_node:
		from_node.connect("delete", delete)
	if to_node:
		to_node.connect("delete", delete)

	width = 3
	default_color = Color.BLACK if !preview else Color.CYAN
	antialiased = true
	points = [Vector2.ZERO, Vector2.ZERO]

func _process(_delta):
	if from_node and to_node:
		points = [
			from_node.get_port_global_position(from_port, false),
	 		to_node.get_port_global_position(to_port, true)
		]
		
func delete():
	queue_free()
