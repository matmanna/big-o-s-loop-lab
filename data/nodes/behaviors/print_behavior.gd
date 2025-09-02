extends NodeBehavior

func evaluate(inputs: Dictionary) -> Dictionary:
	print('hi', inputs["log"])
	if "log" in inputs:
		if typeof(inputs["log"]) == TYPE_FLOAT:
			inputs["scene"].get_node("Debug").print(str(inputs["log"]), inputs["trace"])
		elif typeof(inputs["log"]) == TYPE_INT:
			inputs["scene"].get_node("Debug").print(str(inputs["log"]), inputs["trace"])
		else:
			inputs["scene"].get_node("Debug").print(inputs["log"], inputs["trace"])

		print("Official Logs", inputs["log"], inputs["trace"])
		return {}
	else:
		inputs["scene"].get_node("Debug").warn("Nothing to print", inputs["trace"])
		return {}
