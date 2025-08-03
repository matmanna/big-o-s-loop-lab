extends NodeBehavior

func check_int_or_float(x):
	if x && ((typeof(x) == TYPE_INT || typeof(x) == TYPE_FLOAT)):
		return true
	else:
		return false

func evaluate(inputs: Dictionary) -> Dictionary:
	print('player walk try', inputs["x"])
	if "x" in inputs && check_int_or_float(inputs["x"]):
		return {"succeeded": Level.player.walk(inputs["x"])}
	else:
		Debug.warn("Invalid walk value (must be float or int)", inputs["trace"])
		return {"succeeded": 0}
