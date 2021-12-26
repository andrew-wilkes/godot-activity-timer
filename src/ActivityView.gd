extends Control

signal show_list

var act: Activity
var id

func _ready():
	if get_parent().name == "root":
		# Test
		setup(-1, Activity.new())


func setup(_id, _act: Activity):
	id = _id
	act = _act
	show()
	set_button_states()
	if act.new:
		$Menu/Title.text = ""
		$Menu/Title.grab_focus()
		act.new = false
	else:
		$Menu/Title.text = act.title
		update_time()
		$Notes.text = act.notes
	$Time/ColorPicker.modulate = act.color_code
	update_last_start()
	update_last_stop()


func update_time():
	$Time/TimeDisplay.update_time(act.time)


func _on_Start_pressed():
	act.stopped = false
	act.start_time = OS.get_unix_time()
	update_last_start()
	set_button_states()


func _on_Stop_pressed():
	act.stop_time = OS.get_unix_time()
	if not act.stopped: # Don't log a reset in stopped state
		update_last_stop()
	act.stopped = true
	set_button_states()


func set_button_states():
	$Time/Start.visible = act.stopped
	$Time/Stop.visible = not act.stopped


func _on_Reset_pressed():
	act.time = 0
	_on_Stop_pressed()
	$Time/TimeDisplay.update_time(0)


func _on_Delete_pressed():
	$c/Confirm.popup_centered()


func _on_Confirm_confirmed():
	Data.activities.items.erase(id)
	Data.activities.order.erase(id)
	Data.save_activities()
	emit_signal("show_list")


func _on_ColorPicker_color_changed(color):
	act.color_code = color


func _on_Title_text_changed(new_text):
	act.title = new_text


func update_last_start():
	prints(act.start_time, act.stop_time)
	update_datetime($Stats/LastStart, act.start_time)


func update_last_stop():
	prints(act.start_time, act.stop_time)
	update_datetime($Stats/LastStop, act.stop_time)


func update_datetime(node: Label, time: int):
	if time == 0:
		node.text = ""
	else:
		var dict = OS.get_datetime_from_unix_time(time)
		dict.erase("dst")
		dict.erase("weekday")
		print(dict)
		node.text = "%02d:%02d:%02d %0d-%02d-%02d" % dict.values()


func _on_ColorPicker_pressed():
	$c/ColorGridPanel.popup_centered()


func _on_ColorGridPanel_color_changed(color):
	act.color_code = color
	$Time/ColorPicker.modulate = color


func _on_List_pressed():
	Data.save_activities()
	emit_signal("show_list")


func _on_Timer_timeout():
	if visible and not act.stopped:
		update_time()


func _on_Notes_text_changed():
	act.notes = $Notes.text
