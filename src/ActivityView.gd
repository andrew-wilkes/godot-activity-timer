extends Control

signal home_button_pressed
signal start_button_pressed(id)
signal stop_button_pressed(id)
signal reset_button_pressed(id)
signal delete_button_pressed(id)
signal color_changed(color)

var id

func _on_Home_pressed():
	emit_signal("home_button_pressed")


func _on_Start_pressed():
	emit_signal("start_button_pressed", id)


func _on_Stop_pressed():
	emit_signal("stop_button_pressed", id)


func _on_Reset_pressed():
	emit_signal("reset_button_pressed", id)


func _on_Delete_pressed():
	emit_signal("delete_button_pressed", id)


func _on_ColorPicker_color_changed(color):
	act.color_code = color
	emit_signal("color_changed", id)


func _on_Title_text_changed(new_text):
	pass # Replace with function body.
