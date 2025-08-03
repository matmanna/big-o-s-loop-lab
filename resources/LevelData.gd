extends Resource
class_name LevelData

@export var scene: PackedScene
@export var name := "Unnamed Level"
@export var tick_limit: int
@export var dynamic_tick_limit = false
@export var tick_limit_var: String
@export var tick_limit_var_offset:int
@export var randomized_vars : Array[RandomizedVar]
