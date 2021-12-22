extends PopupPanel

signal color_changed(color)

func _ready():
	var b = $Grid/B1
	for n in 32:
		var button: TextureButton
		if n > 0:
			button = b.duplicate()
			$Grid.add_child(button)
		else:
			button = b
		# Switch between saturated and pastel palettes
		var s = 0.5 if n > 15 else 1.0
		button.modulate =  Color.from_hsv(fmod(n / 15.0, 2.0), s, 1.0)
		var _e = button.connect("pressed", self, "change_color", [button])
	if get_parent().name == "root":
		# Test
		show()


func change_color(button):
	hide()
	emit_signal("color_changed", button.modulate)
