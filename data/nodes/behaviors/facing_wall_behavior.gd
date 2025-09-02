extends NodeBehavior

func evaluate(inputs: Dictionary) -> Dictionary:
	print('hivars', inputs["variables"])
	if inputs["variables"].has("facing_goal"):
		if (inputs["variables"].facing_goal):	
			return {"": 1}
		else:
			return {"": 0}
	else:
		inputs["scene"].get_node("Debug").error("Something's wrong with the facing_goal variable")
		return {"": 0}
