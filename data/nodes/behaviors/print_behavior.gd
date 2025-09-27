extends NodeBehavior

func evaluate(inputs: Dictionary) -> Dictionary:
	print('hi', inputs["log"])
	if "log" in inputs:
		if typeof(inputs["log"]) == TYPE_FLOAT:
			Debug.print(str(inputs["log"]), inputs["trace"])
		elif typeof(inputs["log"]) == TYPE_INT:
			Debug.print(str(inputs["log"]), inputs["trace"])
		else:
			Debug.print(inputs["log"], inputs["trace"])

		print("Official Logs", inputs["log"], inputs["trace"])
		return {}
	else:
		Debug.warn("Nothing to print", inputs["trace"])
		return {}
