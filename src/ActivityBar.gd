extends PanelContainer

signal view_request(id)
signal drag_drop_request(this, pressed)

var id
var running = false
var dragging = false
var act: Activity

func _ready():
	if get_parent().name == "root":
		# Test
		$H/Stop.hide()
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


func setup(_act: Activity):
	$H/Title.text = _act.title
	show_start_button(_act.stopped())
	$H/TimeDisplay.update_time(_act.get_elapsed_time())
	$H/ColorRect.color = _act.color_code
	act = _act


func _on_View_pressed():
	emit_signal("view_request", id)


func _on_Start_pressed():
	act.add_timestamp()
	set_time_color(false)
	show_start_button(false)


func _on_Stop_pressed():
	act.add_timestamp()
	set_time_color(true)
	show_start_button(true)


func set_time_color(stopped: bool):
	$H/TimeDisplay.set_color(stopped)


func show_start_button(show):
	$H/Stop.visible = not show
	$H/Start.visible = show


func _on_Title_mouse_entered():
	$H/Title.set_default_cursor_shape(Input.CURSOR_DRAG)


func _on_Title_mouse_exited():
	$H/Title.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_Timer_timeout():
	if not act.stopped():
		$H/TimeDisplay.update_time(act.get_elapsed_time())


func _on_Title_button_down():
	emit_signal("drag_drop_request", self, true)


func _on_Title_button_up():
	emit_signal("drag_drop_request", self, false)
