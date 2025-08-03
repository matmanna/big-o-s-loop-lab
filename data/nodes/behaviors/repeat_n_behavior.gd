extends NodeBehavior

func evaluate(inputs: Dictionary) -> Dictionary:
	print('repeat n evaluating', inputs)
	if (inputs["iterator"] < inputs["n"]):
		return { "loop": true, "output": false }
	else:
		return { "loop": false, "output": true}
