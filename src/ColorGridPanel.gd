extends PopupPanel

signal color_changed(color)

func _ready():
	for button in $Grid.get_children():
		var _e = button.connect("pressed", self, "change_color", [button])
	if get_parent().name == "root":
		# Test
		show()


func change_color(button):
	hide()
	emit_signal("color_changed", button.modulate)
