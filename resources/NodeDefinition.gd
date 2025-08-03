class_name NodeDefinition
extends Resource

@export var id: String
@export var display_name: String
@export var category: String
@export var iteratorDefault: int = 0
@export var iteratorAmount: String
@export var icon: Texture
@export var condition: String
@export var color: String
@export var input_ports: Array[PortData]
@export var output_ports: Array[PortData]
@export var behavior: NodeBehavior
@export var help_msg: String  = ""
@export var disabled = false
