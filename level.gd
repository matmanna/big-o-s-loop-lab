extends Node2D

@onready var player = $Player
@export var vars: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Level.player = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(_body: Node2D) -> void:
	Level.target_reached = true
	Debug.print('LEVEL TARGET REACHED')
