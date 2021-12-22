extends PanelContainer

signal start_request(this)
signal stop_request(this)
signal view_request(id)
signal drag_drop_request(this, pressed)

var id
var running = false
var dragging = false

func _ready():
	$H/Stop.hide()
	if get_parent().name == "root":
		# Test
		$H/Title.text = "33s"
		$H/TimeDisplay.update_time(33)
		yield(get_tree().create_timer(2.0), "timeout")
		$H/Title.text = "10 minutes and 10s"
		$H/TimeDisplay.update_time(610)
		yield(get_tree().create_timer(2.0), "timeout")
		$H/Title.text = "10 hours 10 mins and 10s"
		$H/TimeDisplay.update_time(36610)
		yield(get_tree().create_timer(2.0), "timeout")
		$H/Title.text = "1000 hours"
		$H/TimeDisplay.update_time(3600000)


func _on_View_pressed():
	emit_signal("view_request", id)


func _on_Title_toggled(button_pressed):
	emit_signal("drag_drop_request", self, button_pressed)


func _on_Start_pressed():
	emit_signal("start_request", self)
	$H/Stop.show()
	$H/Start.hide()


func _on_Stop_pressed():
	emit_signal("stop_request", self)
	$H/Stop.hide()
	$H/Start.show()


func _on_Title_mouse_entered():
	$H/Title.set_default_cursor_shape(Input.CURSOR_DRAG)


func _on_Title_mouse_exited():
	$H/Title.set_default_cursor_shape(Input.CURSOR_ARROW)