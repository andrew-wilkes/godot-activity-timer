extends Control

signal show_list

var act: Activity
var key = 0

func _ready():
	if get_parent().name == "root":
		# Test
		setup(null, Activity.new(), true)


func setup(_key, _act: Activity, new = false):
	key = _key
	act = _act
	set_button_states()
	if new:
		$Menu/Title.editable = false
		$Menu/Title.text = "Add title"
		yield(get_tree().create_timer(2.0), "timeout")
		$Menu/Title.text = ""
		$Menu/Title.editable = true
	else:
		$Menu/Title.text = act.title
		$Menu/ColorPicker.modulate = act.color_code
		$Notes.text = act.notes
	$Menu/Title.grab_focus()
	update_last_start()
	update_last_stop()


func update_time():
	$Menu/TimeDisplay.update_time(act.time)


func _on_Home_pressed():
	emit_signal("show_list")


func _on_Start_pressed():
	act.stopped = false
	act.start_time = OS.get_unix_time()
	update_last_start()
	set_button_states()


func _on_Stop_pressed():
	act.stopped = true
	act.stop_time = OS.get_unix_time()
	update_last_stop()
	set_button_states()


func set_button_states():
	$Menu/Start.visible = act.stopped
	$Menu/Stop.visible = not act.stopped


func _on_Reset_pressed():
	act.time = 0
	$Menu/TimeDisplay.update_time(0)
	$LastStart.text = ""
	$LastStop.text = ""


func _on_Delete_pressed():
	$c/Confirm.popup_centered()


func _on_Confirm_confirmed():
	Data.activities.erase(key)
	emit_signal("show_list")


func _on_ColorPicker_color_changed(color):
	act.color_code = color


func _on_Title_text_changed(new_text):
	act.title = new_text


func update_last_start():
	update_datetime($LastStart, act.start_time, "Last start time: ")


func update_last_stop():
	update_datetime($LastStop, act.stop_time, "Last stop time: ")


func update_datetime(node: Label, time: int, txt: String):
	if time == 0:
		node.visible = false
	else:
		node.visible = true
		var dict = OS.get_datetime_from_unix_time(time)
		dict.erase("dst")
		dict.erase("weekday")
		node.text = txt + "\t%02d:%02d:%02d %0d-%02d-%02d" % dict.values()


func _on_ColorPicker_pressed():
	$c/ColorGridPanel.popup_centered()


func _on_ColorGridPanel_color_changed(color):
	act.color_code = color
	$Menu/ColorPicker.modulate = color
