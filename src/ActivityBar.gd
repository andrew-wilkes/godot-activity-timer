extends PanelContainer

signal start_request(this)
signal stop_request(this)
signal view_request(id)
signal drag_drop_request(this, pressed)

var id
var running = false
var dragging = false

func _ready():
	set_styles($H/Start)
	set_styles($H/Stop)
	set_styles($H/View)
	$H/Stop.hide()
	if get_parent().name == "root":
		# Test
		$H/Title.text = "33s"
		update_time(33)
		yield(get_tree().create_timer(2.0), "timeout")
		$H/Title.text = "10 minutes and 10s"
		update_time(610)
		yield(get_tree().create_timer(2.0), "timeout")
		$H/Title.text = "10 hours 10 mins and 10s"
		update_time(36610)
		yield(get_tree().create_timer(2.0), "timeout")
		$H/Title.text = "1000 hours"
		update_time(3600000)


func _on_View_pressed():
	emit_signal("view_request", id)


func _on_Title_toggled(button_pressed):
	emit_signal("drag_drop_request", self, button_pressed)


func update_time(secs):
	$H/Time.text = "%02d:%02d:%02d" % [secs / 3600, secs % 3600 / 60, secs % 60]


func _on_Start_pressed():
	emit_signal("start_request", self)
	$H/Stop.show()
	$H/Start.hide()


func _on_Stop_pressed():
	emit_signal("stop_request", self)
	$H/Stop.hide()
	$H/Start.show()


func set_styles(button: Button):
	var style = button.get("custom_styles/normal")
	if style == null:
		return # Stick with default button style
	var next_style = set_style(button, style, "custom_styles/hover")
	next_style = set_style(button, next_style, "custom_styles/pressed")


func set_style(button, style, path):
	var new_style = style.duplicate()
	new_style.bg_color = new_style.bg_color.darkened(0.2)
	button.set(path, new_style)
	return new_style
