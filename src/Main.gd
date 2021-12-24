extends Container

func _ready():
	var ws = OS.get_window_safe_area()
	set("custom_constants/margin_top", ws.position.y + 10.0)
	set("custom_constants/margin_bottom", ws.end.y + 10.0)


func show_list():
	$ActivityList.show()


func _on_Add_pressed():
	pass # Replace with function body.


func _on_Activity_home_button_pressed():
	show_list()
