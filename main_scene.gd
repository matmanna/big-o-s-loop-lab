extends Control

@onready var wire_layer = %WireLayer
@onready var preview_line = %PreviewLine
@onready var node_canvas = %NodeCanvas

@export var wire_scene := preload("res://wire.tscn")
@export var logic_node_scene := preload("res://logic_node.tscn")

var is_connecting: bool = false
var current_dialogue = "start"
var start_node: LogicNode = null
var start_port_name: String = ""
var start_is_output: bool = false

var wires: Array[WireLine2D] = []

var zoom := 1.0
var pan_offset := Vector2.ZERO
var is_panning := false
var mouse_inside := false
var last_mouse_pos := Vector2.ZERO
@onready var viewport: SubViewport = get_node('../../HSplitContainer/VBoxContainer/VSplitContainer/Viewport/VBoxContainer/AspectRatioContainer/SubViewportContainer/SubViewport')
var old_level: int = -1
var global_fallback = null

func _ready():
	get_node('../../Level').viewport = viewport
	old_level = get_node('../VBoxContainer/HBoxContainer/OptionButton').selected

	set_process_unhandled_input(true)
	get_node('../../Level').reset()
	get_node('../../Timer').start()


func _on_dialogue_manager_dialogue_ended(resource: DialogueResource):
	if current_dialogue == "start":
		pass

func _process(_delta):
	if is_connecting and start_node:
		preview_line.set_point_position(1, get_global_mouse_position())

func zoom_at_mouse(factor, mouse_pos, total=null):
	if (!total && (zoom * factor < 0.33) && (factor < 1)):
		%ZoomOut.disabled = true
		return
	if (!total && ((zoom * factor) > 1.5) && (factor > 1)):
		%ZoomIn.disabled = true
		return
	%ZoomIn.disabled = false
	%ZoomOut.disabled = false
	var before = (mouse_pos - node_canvas.position) / zoom
	zoom *= factor
	print('node zoom', zoom)
	if total:
		zoom = total
	node_canvas.scale = Vector2.ONE * zoom
	var after = (mouse_pos - node_canvas.position) / zoom
	node_canvas.position += (after - before) * zoom
	if (zoom > 1):
		%ZoomOption.selected = round((zoom-1.25)/0.25)+3
	else:
		%ZoomOption.selected = round((zoom)/0.25)-1

func _unhandled_input(event: InputEvent):
	if mouse_inside && event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			#zoom *= 1.1
			#node_canvas.scale = Vector2.ONE * zoom
			zoom_at_mouse(1.1, event.position)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			#zoom /= 1.1
			#node_canvas.scale = Vector2.ONE * zoom
			zoom_at_mouse(0.91,  event.position)
		elif is_connecting and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			cancel_connection()

		$VSplitContainer/CanvasPanel/Canvas/Wires.position = Vector2(-15, -32) / (zoom**0.1)

func start_connection(from_node: LogicNode, port_name: String):
	#var port = from_node.output_ports[port_name]
	var matches := from_node.definition.output_ports.filter(func(p): return p.name == port_name)
	if matches.is_empty():
		print("Output port definition not found:", from_node)
		cancel_connection()
		return
	var port_data: PortData = matches[0]
	if from_node.output_connections[port_name].size() >= port_data.max_connections:
		print("Max connections reached for output port: ", port_name)
		return

	is_connecting = true
	start_node = from_node
	start_port_name = port_name
	start_is_output = true

	preview_line.clear_points()
	preview_line.add_point(from_node.get_port_global_position(port_name, false))
	preview_line.add_point(get_global_mouse_position())

func complete_connection(to_node: LogicNode, port_name: String):
	if not is_connecting or start_node == null:
		return

	if start_node == to_node:
		cancel_connection()
		return

	var from_node = start_node
	var from_port = start_port_name
	var to_port = port_name

	var matches := to_node.definition.input_ports.filter(func(p): return p.name == port_name)
	if matches.is_empty():
		print("Input port definition not found:", to_port)
		cancel_connection()
		return
	
	var port_data: PortData = matches[0]
	if to_node.input_connections[to_port].size() >= port_data.max_connections:
		print("Max connections reached for input port: ", to_port)
		cancel_connection()
		return


	var wire: WireLine2D = wire_scene.instantiate()
	wire.from_node = from_node
	wire.from_port = from_port
	wire.to_node = to_node
	wire.to_port = to_port
	wire_layer.add_child(wire)
	wires.append(wire)

	print('neigh create', from_node.output_connections[from_port].size(), to_node.input_connections[to_port].size())
	to_node.delete.connect(from_node.neighborDeleted.bind([to_node.input_connections[to_port].size(), from_port, 1]))
	from_node.delete.connect(to_node.neighborDeleted.bind([from_node.output_connections[from_port].size(), to_port, -1]))
	from_node.output_connections[from_port].append(to_node)
	from_node.output_port_connections[from_port].append({"node": to_node, "port": to_port})
	to_node.input_connections[to_port].append(from_node)
	to_node.input_port_connections[to_port].append({"node": from_node, "port": from_port})


	cancel_connection()

func cancel_connection():
	preview_line.clear_points()
	is_connecting = false
	start_node = null
	start_port_name = ""
	start_is_output = false


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if is_connecting and event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				cancel_connection()
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			is_panning = event.pressed
			last_mouse_pos = event.position
	elif event is InputEventMouseMotion and is_panning:
		var delta = event.position - last_mouse_pos
		pan_offset += delta
		node_canvas.position += delta
		last_mouse_pos = event.position

	
func _on_zoom_in_pressed() -> void:
	print('node zoomin')
	zoom_at_mouse(1.1,Vector2(-1186.5, -1299) * node_canvas.scale)


func _on_canvas_mouse_entered() -> void:
	mouse_inside= true


func _on_canvas_mouse_exited() -> void:
	mouse_inside = false

func _on_zoom_out_pressed() -> void:
	zoom_at_mouse(0.91,Vector2(-1186.5, -1299) * node_canvas.scale)


func _on_help_button_pressed() -> void:
	$VSplitContainer/CanvasPanel/HelpButton.get_tooltip()
	pass

func _on_option_button_item_selected(index: int) -> void:
	var zoomLevels = [
		0.33, 0.50, 1.0, 1.25, 1.5
	]
	zoom_at_mouse(0, Vector2.ZERO, zoomLevels[index])

func addNode(event, node_id):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
		var node = logic_node_scene.instantiate()
		node.node_id = node_id[0]
		node.position = Vector2(1300, 1400)
		node_canvas.add_child(node)


func _on_canvas_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if is_connecting and event is InputEventMouseButton and event.pressed:

			if event.button_index == MOUSE_BUTTON_LEFT:
				cancel_connection()


func _on_button_pressed() -> void:
	node_canvas.position = Vector2(-1186.5, -1299) * node_canvas.scale

func _on_reset_level_pressed() -> void:
	get_node('../../Level').reset()
	get_node('../../NodeDatabase').reset()
	get_node('../../LevelDatabase').reset()
	get_node('../../Debug').run_succeeded = null

var pending_level_idx = -1

func _on_level_option_button_item_selected(index: int) -> void:
	pending_level_idx = index
	get_node('../AcceptDialog').show()

func _on_accept_dialog_confirmed() -> void:
	print('switching level', pending_level_idx)
	if pending_level_idx > -1:
		get_node('../../Level').load_level(get_node('../../LevelDatabase').levels.keys()[pending_level_idx])
		pending_level_idx = -1


func start_dialogue():
	print(get_node('../../Level').current_level_name)
	#if (Level.current_level_name == "Starting From Scratch"):
		#DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
		#DialogueManager.show_example_dialogue_balloon(load("res://dialogue/tutorial.dialogue"), "start")
	#elif (Level.current_level_name == "First Loops"):
		#DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)
		#DialogueManager.show_example_dialogue_balloon(load("res://dialogue/tutorial.dialogue"), "firstloop")
	


func _on_timer_timeout() -> void:
	start_dialogue()


func _on_tutorial_button_pressed() -> void:
	start_dialogue()


func _on_accept_dialog_canceled() -> void:
	get_node('../VBoxContainer/HBoxContainer/OptionButton').selected = old_level
	old_level = -1
	get_node('../../Timer').start()
	pending_level_idx = -1
