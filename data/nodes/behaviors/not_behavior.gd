extends NodeBehavior

func evaluate(inputs: Dictionary) -> Dictionary:
	if "a" in inputs && inputs["a"] != null && (typeof(inputs["a"]) == TYPE_INT || typeof(inputs["a"]) == TYPE_FLOAT):
		return {"": 1 if (inputs["a"] != 1) else 0}
	else:
		inputs["scene"].get_node("Debug").warn("Invalid boolean passed to not")
		return {"": 0}
