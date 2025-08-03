extends NodeBehavior

func check_raisable(a, b):
	if a && b && (typeof(a) == TYPE_INT || typeof(a) == TYPE_FLOAT) && (typeof(b) == TYPE_INT || typeof(b) == TYPE_FLOAT):
		return true
	else:
		return false

func evaluate(inputs: Dictionary) -> Dictionary:
	if "base" in inputs && "exponent" in inputs && check_raisable(inputs["base"], inputs["exponent"]):
		return {"power": inputs["base"] ** inputs["exponent"]}
	else:
		print("Official Log: Invalid base or exponent")
		return {}
