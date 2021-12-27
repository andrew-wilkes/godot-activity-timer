extends VBoxContainer

signal show_list

func _on_List_pressed():
	emit_signal("show_list")


func _on_Donate_pressed():
	var _e = OS.shell_open("https://paypal.me/GDScriptDude?country.x=GB&locale.x=en_GB")


func _on_Save_pressed():
	var _e = Data.save_string("Test", "user://test.txt")
