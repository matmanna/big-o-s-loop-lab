extends NodeBehavior

func check_subtractable(a, b):
	if a != null && b != null && (typeof(a) == TYPE_INT || typeof(a) == TYPE_FLOAT) && (typeof(b) == TYPE_INT || typeof(b) == TYPE_FLOAT):
		return true
	else:
		return false

func evaluate(inputs: Dictionary) -> Dictionary:
	if "minuend" in inputs && "subtrahend" in inputs && check_subtractable(inputs["minuend"], inputs["subtrahend"]):
		return {"difference": inputs["minuend"] - inputs["subtrahend"]}
	else:
		print("Official Log: Invalid minuend or subtrahend")
		return {}
