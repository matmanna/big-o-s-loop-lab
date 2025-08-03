extends NodeBehavior

func check_multiplable(a, b):
	if a != null && b != null && (typeof(a) == TYPE_INT || typeof(a) == TYPE_FLOAT) && (typeof(b) == TYPE_INT || typeof(b) == TYPE_FLOAT):
		return true
	else:
		return false

func evaluate(inputs: Dictionary) -> Dictionary:
	if "multiplicand" in inputs && "multiplier" in inputs && check_multiplable(inputs["multiplicand"], inputs["multiplier"]):
		return {"product": inputs["multiplicand"] * inputs["multiplier"]}
	else:
		print("Official Log: Invalid factors")
		return {}
