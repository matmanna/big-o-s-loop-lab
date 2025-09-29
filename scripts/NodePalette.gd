extends PanelContainer

@onready var nodeCategories = [
	{"name": "📡 Events", "icon": "res://assets/ui_pack/Extra/icon_play_dark.svg", "tabIcon": preload("res://assets/tab_emojis/satellite-antenna.png")},
	{"name": "🔁 Loops", "icon": "res://assets/ui_pack/Extra/icon_repeat_dark.svg", "tabIcon": preload("res://assets/tab_emojis/repeat-button.png")},
	{"name": '✅ Conditions', "icon":"res://assets/ui_pack/Grey/icon_outline_checkmark.svg", "tabIcon": preload("res://assets/tab_emojis/check-mark-button.png")},
	{"name": "⭐ Actions", "icon": "res://assets/ui_pack/Grey/star.svg", "tabIcon": preload("res://assets/tab_emojis/star.png" )},
	{"name": '🚩 Data', "icon":"res://assets/ui_pack/Grey/icon_outline_checkmark.svg", "tabIcon": preload("res://assets/tab_emojis/triangular-flag.png")},
	{"name": '🧮 Math', "icon": "", "tabIcon": preload("res://assets/tab_emojis/abacus.png") }
]
#@onready var categories = $VBoxContainer/Categories

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var num = 0
	for cat in nodeCategories:
		var scroll = ScrollContainer.new()
		scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		var grid = GridContainer.new()
		grid.columns = 1
		grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		scroll.name = cat.name.split(" ")[1]
		for node in NodeDatabase.definitions.keys():
			if NodeDatabase.definitions[node].category == cat.name and !NodeDatabase.definitions[node].disabled:
				var nodeContainer = HBoxContainer.new()
				nodeContainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				var nodePanel = PanelContainer.new()
				var title = Label.new()
				title.text = NodeDatabase.definitions[node].display_name
				var icon = TextureRect.new()
				icon.custom_minimum_size = Vector2(20, 20)
				icon.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
				icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				icon.texture = NodeDatabase.definitions[node].icon
				var hbox = HBoxContainer.new()
				hbox.add_child(icon)
				hbox.add_child(title)
				nodePanel.add_child(hbox)
				nodePanel.theme_type_variation = NodeDatabase.definitions[node].color
				nodePanel.gui_input.connect(get_node('../../').addNode.bind([NodeDatabase.definitions[node].id]))
				var helpLabel = Label.new()
				helpLabel.text = NodeDatabase.definitions[node].help_msg
				helpLabel.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
				helpLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				nodeContainer.add_child(nodePanel)
				nodeContainer.add_child(helpLabel)
				grid.add_child(nodeContainer)
		scroll.add_child(grid)
		%PaletteTabs.add_child(scroll)
		#var image = Image.load_from_file(cat.tabIcon)
		#var texture = ImageTexture.create_from_image(image)
		%PaletteTabs.set_tab_icon(len(%PaletteTabs.get_children())-1, cat.tabIcon)
		%PaletteTabs.set_tab_icon_max_width(len(%PaletteTabs.get_children())-1, 18)
		#$VBoxContainer/TabContainer.set_tab_icon(num, load( cat.icon))
		#num +=1
	%PaletteTabs.current_tab = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
