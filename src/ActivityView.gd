extends Control

signal show_list

var act: Activity
var id
var choosing_color = false

func _ready():
	$RefreshTimer.wait_time = 3
	if get_parent().name == "root":
		# Test
		setup(-1, Activity.new())


func setup(_id, _act: Activity):
	id = _id
	act = _act
	show()
	if act.new:
		$Menu/Title.text = ""
		$Menu/Title.grab_focus()
		$Notes.text = ""
		act.new = false
	else:
		$Menu/Title.text = act.title
		$Notes.text = act.notes
	$Time/ColorPicker.modulate = act.color_code
	update_time()
	update_history()
	update_last_start()
	update_last_stop()
	set_button_states()


func update_history():
	act.history = $VB/History.apply_data(act.history)
	#$VB/History.apply_data($VB/History.get_test_data(4))
	$VB/Days.update_days()	


func update_time():
	$Time/TimeDisplay.update_time(act.get_elapsed_time())


func _on_Start_pressed():
	act.add_timestamp()
	update_last_start()
	set_button_states()
	$RefreshTimer.start(2.0)


func _on_Stop_pressed():
	$RefreshTimer.stop()
	act.add_timestamp()
	update_last_stop()
	update_history()
	set_button_states()


func set_button_states():
	var stopped = act.stopped()
	$Time/Start.visible = stopped
	$Time/Stop.visible = not stopped
	$Time/TimeDisplay.set_color(stopped)


func _on_Reset_pressed():
	act.reset()
	$Time/TimeDisplay.update_time(0)


func _on_Delete_pressed():
	$c/Confirm.popup_centered()


func _on_Confirm_confirmed():
	Data.activities.items.erase(id)
	Data.activities.order.erase(id)
	Data.save_activities()
	act = null
	emit_signal("show_list")


func _on_Title_text_changed(new_text):
	act.title = new_text


func update_last_start():
	update_datetime($Stats/LastStart, act.get_last_start_time())


func update_last_stop():
	update_datetime($Stats/LastStop, act.get_last_stop_time())


func update_datetime(node: Label, time: int):
	if time == 0:
		node.text = ""
	else:
		var dict = OS.get_datetime_from_unix_time(time)
		dict.erase("dst")
		dict.erase("weekday")
		node.text = "%02d:%02d:%02d %0d-%02d-%02d" % dict.values()


func _on_ColorPicker_pressed():
	if choosing_color:
		choosing_color = false
	else:
		choosing_color = true
		$c/ColorGridPanel.popup_centered()


func _on_ColorGridPanel_color_changed(color):
	act.color_code = color
	choosing_color = false
	$Time/ColorPicker.modulate = color


func _on_List_pressed():
	$RefreshTimer.stop()
	Data.save_activities()
	emit_signal("show_list")


func _on_Timer_timeout():
	if visible and act and not act.stopped():
		update_time()


func _on_Notes_text_changed():
	act.notes = $Notes.text


func _on_RefreshTimer_timeout():
	update_history()
	var time_to_next_hour = 3600 - OS.get_unix_time() % 3600
	$RefreshTimer.start(time_to_next_hour)
