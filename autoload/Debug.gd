extends Node

@export var logs = []
@onready var logsbox = null
var old_logs_size = 0
var run_succeeded = null

var logColors = {
	"log": Color.BLUE,
	"warn": Color.ORANGE,
	"error": Color.RED,
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func add_log_child(size):
	run_succeeded = true
	print(logsbox)
	if (!logsbox):
		return;
	var size_to = logs.size()
	print(logs.size())
	old_logs_size = size_to
	var i = size
	while i<size_to:
		var hbox = HBoxContainer.new()
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var type = Label.new()
		type.modulate = logColors[ logs[i].type]
		type.text = logs[i].type
		type.uppercase= true
		var msg = Label.new()
		msg.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		msg.text = logs[i].content
		msg.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(type)
		hbox.add_child(msg)

		logsbox.add_child(hbox)
		i+=1

func print(log, trace=null):
	logs.append({"type": "log", "content": log, "trace": trace, "time": Time.get_unix_time_from_system()})

func warn(log, trace=null):
	logs.append({"type": "warn", "content": log, "trace": trace, "time": Time.get_unix_time_from_system()})

func error(log, trace=null):
	run_succeeded = false
	logs.append({"type": "error", "content": log, "trace": trace, "time": Time.get_unix_time_from_system()})

func get_run_status():
	return {"text": "FAILED", "color": "PanelContainerDanger"} if run_succeeded == false else ( {"text": "N/A", "color": "PanelContainerWarning"} if run_succeeded == null else {"text": "SUCCESS", "color": "PanelContainerSuccess"})

func reset():
	old_logs_size = 0
	logs = []
	logsbox = get_tree().root.get_node('MainScene/HSplitContainer/VBoxContainer/VSplitContainer/Debugger/VBoxContainer/DebugTabs/Logs/LogsBox')
	print('logsbox', logsbox)
	for i in range(0, logsbox.get_child_count()):
		logsbox.get_child(i).queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if old_logs_size < logs.size():
		print('adding log children')
		if (!logs.size()>100):
			add_log_child(old_logs_size)
		else:
			pass
