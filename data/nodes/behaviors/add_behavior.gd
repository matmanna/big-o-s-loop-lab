extends NodeBehavior

func check_addable(a, b):
	if (a && b && ((typeof(a) == TYPE_INT || typeof(a) == TYPE_FLOAT || (typeof(a) == TYPE_STRING && typeof(b)==TYPE_STRING)) and (typeof(b) == TYPE_INT || typeof(b) == TYPE_FLOAT || (typeof(b) == TYPE_STRING and typeof(a) == TYPE_STRING)))):
		return true
	else:
		false

func evaluate(inputs: Dictionary) -> Dictionary:
	if "addand1" in inputs && "addand2" in inputs && check_addable(inputs["addand1"], inputs["addand2"]):
		return {"sum": inputs["addand1"] + inputs["addand2"]}
	else:
		print("Official Log: Invalid addands")
		return {}
