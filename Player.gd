extends CharacterBody2D

const SPEED = 300.0
var direction = Vector2.UP

func _physics_process(_delta: float) -> void:
	pass

func walk(x):
	print('player walk',  x * direction * 64)
	var vel = x * direction * 64
	var old_pos = position
	var yes = move_and_collide(vel, true)
	print('walk distance', !yes, vel, abs(old_pos - position).length(), Vector2(63,020).length(), position )
	if !yes:
		move_and_collide(vel)
		return 1
	else:
		position  = old_pos
		return 0
		
func facing_wall():
	return $WallRaycast.is_colliding()

func facing_goal():
	#print('neigh', $GoalRaycast.is_colliding())
	return $GoalRaycast.is_colliding()
	

func set_direction(x, y):
	direction = Vector2(x, y ).normalized()
