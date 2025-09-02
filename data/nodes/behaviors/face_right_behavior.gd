extends NodeBehavior

func evaluate(inputs: Dictionary) -> Dictionary:
	inputs["scene"].get_node('Level').player.direction = Vector2(1,  0)
	return {}
