extends Control

@export var node_canvas: Control
@export var highlight_color := Color.YELLOW
@export var tick_interval := 0.6 # seconds between ticks
@export var tick_count = 0 

var current_nodes: Array= []
var next_nodes: Array= []
var is_running := false

func _ready():
	pass
	
var staticValues = {}
var staticPortValues = {}

func get_node_value(node):
	if node.definition_id == "value":
		return staticValues
	else:
		return
		
func get_port_def_by_name(name, ports):
	var portIndex = null
	for i in range(ports.size()):
		var inpr = ports[i]
		print('inpr', i, inpr, name, portIndex)
		
		if (inpr.name == name):
			portIndex = i
	if portIndex == null:
			return false;
	return ports[portIndex]
		
func getPassThroughIn(node):
	var passThroughIn = {}
	for inp in node.input_port_connections:
		print('inp', inp)
		if inp == "input":
			continue;
		var portDef = get_port_def_by_name(inp, node.definition.input_ports)
		#for i in range(node.definition.input_ports.size()):
			#var inpr = node.definition.input_ports[i]
			#
			#print(inpr.name, inp, inp == inpr.name)
			#if (inpr.name == inp):
				#portIndex = i
		if !portDef:
			return false;
		if (portDef.type == "value"):
			print('heyo', inp, node.input_connections)
			if  node.input_port_connections[inp] and node.input_port_connections[inp].size() > 0:
				print('node is loopy', node.input_port_connections[inp])
				var success = false
				for conn1 in  node.input_port_connections[inp]:
					if conn1.node.get_instance_id() and staticPortValues.has(conn1.node.get_instance_id()):
						print('statport',  inp, staticPortValues[conn1.node.get_instance_id()][conn1.port])
						passThroughIn[inp] = staticPortValues[conn1.node.get_instance_id()][conn1.port]
						success = true
				if success:
					continue
				else:
					pass;
			if !node.input_connections[inp]:
				return false;
			if !node.input_connections[inp][0]:
				return false;
			if !staticValues.has(node.input_connections[inp][0].get_instance_id()):
				return false;
				
			passThroughIn[inp] = staticValues[node.input_connections[inp][0].get_instance_id()]
	print('passthrough', passThroughIn)
	return passThroughIn;

func process_static(node):
	print('outptconn', node.output_connections)
	if node.definition.id == "value":
		var  valueVal = node.get_node("%Value").text
		if valueVal.is_valid_float():
			staticValues[node.get_instance_id()] = valueVal.to_float()
		elif valueVal.is_valid_int():
			staticValues[node.get_instance_id()] = valueVal.to_int()
		else:
			staticValues[node.get_instance_id()] = valueVal
		print('statVal', staticValues)
		var portDef = get_port_def_by_name(node.output_connections.keys()[0], node.definition.output_ports)
		if !portDef:
				return false;

		for out in node.output_connections[node.output_connections.keys()[0]]:
			
			#for i in range(node.definition.input_ports.size()):
				#var inpr = node.definition.input_ports[i]
				#
				#print(inpr.name, inp, inp == inpr.name)
				#if (inpr.name == inp):
					#portIndex = i
			
			if (portDef.type == "value" and out.definition and !get_port_def_by_name("input", out.definition.input_ports)): 
				process_static(out)
	elif node.definition.id == "initalize":
		var  valueVal = node.get_node("%Name").text
		if valueVal.is_valid_float():
			staticValues[node.get_instance_id()] = valueVal.to_float()
		elif valueVal.is_valid_int():
			staticValues[node.get_instance_id()] = valueVal.to_int()
		else:
			staticValues[node.get_instance_id()] = valueVal
		print('statVal', staticValues)
		var portDef = get_port_def_by_name(node.output_connections.keys()[0], node.definition.output_ports)
		if !portDef:
				return false;

		for out in node.output_connections[node.output_connections.keys()[0]]:
			
			#for i in range(node.definition.input_ports.size()):
				#var inpr = node.definition.input_ports[i]
				#
				#print(inpr.name, inp, inp == inpr.name)
				#if (inpr.name == inp):
					#portIndex = i
			
			if (portDef.type == "value" and !get_port_def_by_name("input", out.definition.input_ports)): 
				process_static(out)
	else:
		print('hi')
		var passThroughIn = getPassThroughIn(node)
		print(passThroughIn)
		if (!passThroughIn):
			return;
		print('actually execute')
		passThroughIn.trace = node
		var evalResult =node.evaluate(passThroughIn)
		var relevant_out = null
		print('out eval', evalResult)
		for outp in node.definition.output_ports:
			print('outp', outp.name)
			if evalResult.has(outp.name):
				print('has output')
				relevant_out = outp.name
		if !relevant_out:
			return
		staticValues[node.get_instance_id()] = evalResult[relevant_out]
		print('statVal', staticValues, evalResult)
		var portDef = get_port_def_by_name(node.output_connections.keys()[0], node.definition.output_ports)
			#for i in range(node.definition.input_ports.size()):
				#var inpr = node.definition.input_ports[i]
				#
				#print(inpr.name, inp, inp == inpr.name)
				#if (inpr.name == inp):
					#portIndex = i
		if !portDef:
			return false;
		for out in node.output_connections[node.output_connections.keys()[0]]:
			print('official', out.definition.input_ports)
			if (portDef.type == "value" and !get_port_def_by_name("input", out.definition.input_ports)): 
				process_static(out)

func start_evaluation():
	if is_running:
		return
	get_node('../../../../../VBoxContainer/VSplitContainer/Debugger/VBoxContainer/DebugTabs').current_tab = 1
	Level.reset()
	Level.target_reached = false
	staticValues = {}
	staticPortValues = {}
	Debug.reset()
	print("Official: start")
	Debug.print("Starting evaluation", null)
	print(is_running)
	tick_count = 0 
	

	# Prevent UI interaction
	node_canvas.mouse_filter = Control.MOUSE_FILTER_IGNORE

	is_running = true
	current_nodes.clear()
	next_nodes.clear()
	#loop_nodes.clear()

	for node in node_canvas.get_children():
		print('loop init', node is LogicNode and node.definition.id == "on-start")
		if node is LogicNode and node.definition.id == "on-start":
			var out_conns = node.output_connections["output"] # assume "main" is standard output name
			print('loop init >>', out_conns)
			next_nodes.append_array(out_conns)
			print('loop init >>', next_nodes)
		if node is LogicNode and node.definition.id == "value" and node.output_connections.size() > 0:
			process_static(node)

	print("Officially executing program")
	_process_tick()
	print('program finished')
	
#var loop_nodes: Array[LogicNode] = []

func _process_tick(inside_loop=false, loop_nodes:Array=[]):
	var new_loop_nodes:Array[LogicNode]= []
	print('loop', inside_loop)
	if tick_count > 199:
		stop_evaluation()
	if not is_running:
		return
	tick_count += 1

	if !inside_loop:
		current_nodes = next_nodes.duplicate()
		print('loop -', next_nodes)
		next_nodes.clear()
	else:
		current_nodes = loop_nodes.duplicate()
		loop_nodes.clear()
		print('node loop conn ->', current_nodes)

	if current_nodes.is_empty() && !inside_loop:
		stop_evaluation()
		return
	if current_nodes.is_empty() && inside_loop:
		print('node loop stopping')
		return

	for node in current_nodes:
		print('node loop conn ===> ', node.node_id, node.input_port_connections)
		node.highlight(highlight_color)
		await get_tree().create_timer(tick_interval / 2.0).timeout
		var passThroughIn =getPassThroughIn(node)
		print('loop conn', passThroughIn)
		if (!passThroughIn):
			print('official stop')
			node.unhighlight()
			continue;
		print('executing and passing through', passThroughIn)
		passThroughIn.trace = node
		var iterator = node.definition.iteratorDefault
		if (node.definition.iteratorAmount != ''):
			passThroughIn.iterator = iterator
			if get_port_def_by_name(node.definition.iteratorAmount, node.definition.input_ports):
				if !staticValues[node.input_connections[node.definition.iteratorAmount][0].get_instance_id()]:
					Debug.error("No iteration count passed", node)
					continue
				passThroughIn[node.definition.iteratorAmount] = staticValues[node.input_connections[node.definition.iteratorAmount][0].get_instance_id()]
			else:
				Debug.error("Invalid iteration count", node)
				
		var nodeReturn = node.evaluate(passThroughIn)
		print('nodeReturn', nodeReturn)
		staticPortValues[node.get_instance_id()] = nodeReturn
		node.unhighlight()

		var out_conns = node.output_connections["output"].duplicate()
		print('not a loop', out_conns)
		
		if (out_conns.size() ==0):
			if (inside_loop):
				var portDef = get_port_def_by_name(node.output_connections.keys()[0], node.definition.output_ports)
				if portDef:
					print(node.input_connections)
					for out in node.output_connections[node.output_connections.keys()[0]]:
						print('getting portdef', out)
						
						print('def', portDef)
						#for i in range(node.definition.input_ports.size()):
							#var inpr = node.definition.input_ports[i]
							#
							#print(inpr.name, inp, inp == inpr.name)
							#if (inpr.name == inp):
								#portIndex = i
						
						if (portDef.type == "value" and !get_port_def_by_name("input", out.definition.input_ports)): 
							process_static(out)
					print('node====')
		if node.definition.iteratorAmount != '' and nodeReturn.loop:
			print('loopy',  node.output_connections)
			while nodeReturn.loop:
				var loop_conns:Array = node.output_connections["loop"].duplicate()
				# loop_nodes.clear()
				print('node loop conns', loop_conns.size() > 0, loop_nodes)
				if loop_conns.size() > 0:
					print('node loop processing tick')
					_process_tick(true, loop_conns)
				node.highlight(highlight_color)
				iterator += 1
				passThroughIn.iterator = iterator
				nodeReturn = node.evaluate(passThroughIn)
				staticPortValues[node.get_instance_id()] = nodeReturn
				await get_tree().create_timer(tick_interval).timeout
				node.unhighlight()
					
		if inside_loop:
			new_loop_nodes.append_array(out_conns)
		else:
			next_nodes.append_array(out_conns)

	# Wait a bit, then tick again
	await get_tree().create_timer(tick_interval).timeout
	print('loop ', inside_loop, new_loop_nodes)
	_process_tick(inside_loop, new_loop_nodes)

func stop_evaluation():
	is_running = false
	node_canvas.mouse_filter = Control.MOUSE_FILTER_PASS
	current_nodes.clear()
	next_nodes.clear()


func _on_h_slider_value_changed(value: float) -> void:
	tick_interval = value


func _on_clear_button_pressed() -> void:
	for i in range (0,get_node('../Wires/WireLayer').get_child_count()):
		get_node('../Wires/WireLayer').get_child(i).queue_free()
	for i in range(0, get_child_count()):
		get_child(i)._on_texture_button_pressed()

func _process(_delta):
	var debug_tabs  =  get_node('../../../../../VBoxContainer/VSplitContainer/Debugger/VBoxContainer/DebugTabs')
	var puzzle_result = debug_tabs.get_node('Puzzle/PuzzleResult')
	var player_details=  debug_tabs.get_node('Player/PlayerDetails')
	var tickcount = puzzle_result.get_node('TickCount/Value')
	tickcount.text = str(tick_count)
	var status =  puzzle_result.get_node('Status/Panel')
	status.get_node('Value').text = Debug.get_run_status().text
	status.theme_type_variation = Debug.get_run_status().color
	var solved =  puzzle_result.get_node('Completion/Panel')
	solved.get_node('Value').text = "SUCCESS" if Level.target_reached else ("N/A" if Level.target_reached == null else "FAILED")
	solved.theme_type_variation = "PanelContainerSuccess" if Level.target_reached else ("PanelContainerWarning" if Level.target_reached == null else "PanelContainerDanger")
	var player_position = player_details.get_node('Position/Value') 
	player_position.text = var_to_str(Level.player.position)
	var player_direction = player_details.get_node('Direction/Value') 
	player_direction.text = var_to_str(Level.player.direction)
	var facing_wall = player_details.get_node('FacingWall/Panel') 
	facing_wall.get_node('Value').text = "TRUE" if Level.player.facing_wall()  else "FALSE"
	facing_wall.theme_type_variation = "PanelContainerSuccess" if Level.player.facing_wall()  else  "PanelContainerDanger"
	var facing_goal = player_details.get_node('FacingGoal/Panel') 
	facing_goal.get_node('Value').text = "TRUE" if Level.player.facing_goal()  else "FALSE"
	facing_goal.theme_type_variation = "PanelContainerSuccess" if Level.player.facing_goal()  else  "PanelContainerDanger"
	var level_name = get_node('../../../../../VBoxContainer/HBoxContainer/LevelName')
	level_name.text = "Level: " + Level.current_level_name
