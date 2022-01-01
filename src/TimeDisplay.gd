extends Label

func _ready():
	if get_parent().name == "root":
		# Test
		update_time(8 * 3600 + 100 * 60 + 33)


func update_time(secs):
	text = "%02d:%02d:%02d" % [secs / 3600, secs % 3600 / 60, secs % 60]


func set_color(stopped: bool):
	if stopped:
		modulate = Color.white
	else:
		modulate = Color.green
