extends Control
class_name LogicNode

signal delete

@export var node_id: String
var definition: NodeDefinition


var input_ports: Dictionary = {}   
var output_ports: Dictionary = {}  
var input_connections: Dictionary = {}  
var input_port_connections: Dictionary = {}   
var output_connections: Dictionary = {}  
var output_port_connections: Dictionary = {} 

#@onready var handle = $Panel/VBoxContainer/Handle
@onready var input_list = %InputPortList
@onready var output_list = %OutputPortList
@onready var title_label = $Panel/HBoxContainer/Content
@onready var icon_rect = $Panel/HBoxContainer/Icon


var is_dragging := false
var drag_offset := Vector2.ZERO
func _ready():
	definition = get_node('../../../../../../../NodeDatabase').get_definition(node_id)
	print(node_id)
	if definition == null:
		push_error("Invalid node_id: %s" % node_id)
		return
	print(title_label)
	print(get_children())
	if definition.id == "value":
		$Panel/HBoxContainer/Value.visible = definition.output_ports[0].type == "value"
		$Panel/HBoxContainer/Label.visible = definition.output_ports[0].type == "value"
		$Panel/HBoxContainer/Name.visible = definition.output_ports[0].type == "value" && definition.output_ports[0].name == "editable"
	else:
		$Panel/HBoxContainer/Value.visible = false
		$Panel/HBoxContainer/Name.visible = false
		$Panel/HBoxContainer/Label.visible = false

	title_label.text = definition.display_name
	icon_rect.texture = definition.icon
	#$Panel.modulate = definition.color
	$Panel.theme_type_variation = definition.color
	mouse_filter = MOUSE_FILTER_STOP
	gui_input.connect(_on_handle_gui_input)

	build_ports()

func build_ports():
	for port in definition.input_ports:
		var ui = create_port_ui(port, true)
		input_ports[port.name] = ui
		input_connections[port.name] = []
		input_port_connections[port.name] = []
		input_list.add_child(ui)

	for port in definition.output_ports:
		var ui = create_port_ui(port, false)
		output_ports[port.name] = ui
		output_port_connections[port.name] = []
		output_connections[port.name] = []
		output_list.add_child(ui)

func create_port_ui(port_data: PortData, is_input: bool) -> Control:
	var panel = PanelContainer.new()
	var container = HBoxContainer.new()
	#container.name = port_data.name
	container.mouse_filter = MOUSE_FILTER_STOP

	var icon = TextureRect.new()
	icon.texture = port_data.icon
	icon.custom_minimum_size = Vector2(16, 16)

	var label = Label.new()
	label.text = port_data.name
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	#if is_input:
		#container.add_child(icon)
		#container.add_child(label)
	#else:
	#container.add_child(label)
		#container.add_child(icon)

	#container.modulate = port_data.color
	panel.gui_input.connect(_on_port_input.bind(port_data.name, is_input))
	panel.theme_type_variation = port_data.color
	panel.add_child(container)

	return panel

func _on_port_input(event: InputEvent, port_name: String, is_input: bool):
	if event is InputEventMouseButton and event.pressed:
		if is_input:
			get_tree().root.get_node("MainScene/HSplitContainer/Studio").complete_connection(self, port_name)
		else:
			get_tree().root.get_node("MainScene/HSplitContainer/Studio").start_connection(self, port_name)
			
func _on_handle_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# print('handler')
			if event.pressed:
				is_dragging = true
				drag_offset = get_global_mouse_position() - global_position
			else:
				is_dragging = false

func _process(_delta):
	if is_dragging and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		global_position = get_global_mouse_position() - drag_offset
	elif is_dragging:
		is_dragging = false

func get_port_global_position(port_name: String, is_input: bool) -> Vector2:
	var port = input_ports[port_name] if is_input  else output_ports[port_name]
	return port.get_global_position() + ((port.size / get_tree().root.get_node("MainScene/HSplitContainer/Studio/VSplitContainer/CanvasPanel/Canvas/NodeCanvas").scale) / 4)

var original_modulate := Color.WHITE

func highlight(color: Color):
	original_modulate = Color.WHITE
	modulate = color

func unhighlight():
	modulate = original_modulate

func evaluate(input_data):
	print("Evaluating node:", definition.id, definition.behavior)
	if definition.behavior:
		print('behavior exists')
		print(input_data)
		var output_data = definition.behavior.evaluate(input_data)
		return output_data


func _on_texture_button_pressed() -> void:
	delete.emit()
	queue_free()
	
func clearAllNeighborConnections(direction, port):
	if direction == 1:
		for oc in output_connections[port]:
			oc.disconnect("delete", neighborDeleted)
	else:
		for oc in input_connections[port]:
			oc.disconnect("delete", neighborDeleted)
			
func createNeighborConnections(direction, port):
	if direction == 1:
		for oc in range(0, output_connections[port].size()):
			output_connections[port][oc].delete.connect(neighborDeleted.bind([oc, port, direction]))
	else:
		for oc in range(0, input_connections[port].size()):
			input_connections[port][oc].delete.connect(neighborDeleted.bind([oc, port, direction]))

func indexOfIn(props, list, vals):
	for i in range(0, list.size()):
		for i2 in range(0,props.size()):
			if list[i][props[i2]] == vals[i2]:
				return i
	return -1

func neighborDeleted(data):
	var nIdx = data[0]
	var port = data[1]
	var direction = data[2]
	print('neighbor deletion', data, nIdx)
	print('neigh_a1', output_port_connections, output_connections)
	print('neigh_b1', input_port_connections, input_connections)
	clearAllNeighborConnections(direction, port)
	if direction == 1:
		output_connections[port].remove_at(nIdx)
		output_port_connections[port].remove_at(nIdx)
	else:
		input_connections[port].remove_at(nIdx)
		input_port_connections[port].remove_at(nIdx)
	createNeighborConnections(direction, port)
	print('neigh_a2', output_port_connections, output_connections)
	print('neigh_b2', input_port_connections, input_connections)
