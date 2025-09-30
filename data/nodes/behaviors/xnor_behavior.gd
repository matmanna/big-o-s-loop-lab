extends NodeBehavior

func check_andable(a, b):
	if (a != null && b != null && ((typeof(a) == TYPE_INT || typeof(a) == TYPE_FLOAT) and (typeof(b) == TYPE_INT || typeof(b) == TYPE_FLOAT))):
		return true
	else:
		false

func evaluate(inputs: Dictionary) -> Dictionary:
	if "a" in inputs && "b" in inputs && check_andable(inputs["a"], inputs["b"]):
		return {"": 1 if ((inputs["a"] == 0 && inputs["b"] == 0) || (inputs["a"] == 1 && inputs["b"] == 1)) else 0}
	else:
		Debug.warn("Invalid booleans passed to xnor", inputs["trace"])
		return {"": 0}
