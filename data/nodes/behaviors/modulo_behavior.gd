extends NodeBehavior

func check_dividable(a, b):
	if a != null && b != null && (typeof(a) == TYPE_INT || typeof(a) == TYPE_FLOAT) && (typeof(b) == TYPE_INT || typeof(b) == TYPE_FLOAT):
		return true
	else:
		return false

func evaluate(inputs: Dictionary) -> Dictionary:
	if "dividend" in inputs && "divisor" in inputs && check_dividable(inputs["dividend"], inputs["divisor"]):
		return {"power": inputs["dividend"] % inputs["divisor"]}
	else:
		inputs["scene"].get_node("Debug").error("Invalid dividend or divisor", inputs["trace"])
		return {}
