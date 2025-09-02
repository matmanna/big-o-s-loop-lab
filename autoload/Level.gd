extends Node

@export var viewport:SubViewport = null
@export var world_scene = null
@export var player: CharacterBody2D = null
@export var target_reached = null

@export var current_level_name = "Starting From Scratch"
var current_level_node: Node2D = null


func load_level(level:String):
	current_level_name = level
	reset()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reset():
	var level = get_node('../LevelDatabase').get_level(current_level_name)
	if (!level.scene):
		print('oopsy daisy')
		return;
	var level_scene: PackedScene= level.scene
	var vars = {}
	target_reached = null
	for i in range (0,viewport.get_child_count()):
		viewport.get_child(i).queue_free()
	var tick_limit = 100
	print('rv0', level.randomized_vars)
	for rv in level.randomized_vars:
		print('rv', rv.var_name, rv.use_range, rv.possibleValues)
		if rv.use_range:
			vars[rv.var_name] = randi_range(rv.min_value, rv.max_value) * rv.multiple
		elif rv.possibleValues.size() > 0:
			vars[rv.var_name] = rv.possibleValues[randi_range(0, rv.possibleValues.size())]
	print('rv', vars)
	if (level.dynamic_tick_limit):
			tick_limit = vars[level.tick_limit_var]
	tick_limit += level.tick_limit_var_offset
	world_scene = level_scene.instantiate()
	world_scene.vars = vars

	viewport.add_child(world_scene)
				
