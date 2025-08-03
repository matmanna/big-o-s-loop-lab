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
	var level_scene: PackedScene= LevelDatabase.get_level(current_level_name).scene
	target_reached = null
	for i in range (0,viewport.get_child_count()):
		viewport.get_child(i).queue_free()
	world_scene = level_scene.instantiate()
	viewport.add_child(world_scene)
