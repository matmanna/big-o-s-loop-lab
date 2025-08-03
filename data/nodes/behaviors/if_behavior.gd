extends NodeBehavior

func evaluate(inputs: Dictionary) -> Dictionary:
	if inputs[""] != 0 and inputs[""] != null:
		return {"if": true, "else": false}
	else:
		return {"if": false, "else": true}
