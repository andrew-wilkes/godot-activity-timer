extends Container

func _ready():
	var ws = OS.get_window_safe_area()
	var top_margin = ws.position.y + 40.0
	$ActivityList.top_margin = top_margin
	set("custom_constants/margin_top", top_margin)
	set("custom_constants/margin_bottom", ws.end.y + 10.0)
	$ActivityView.rect_size.y = ws.size.y


func _on_ActivityList_view_clicked(id):
	$ActivityList.clear_list()
	$ActivityView.setup(id, Data.activities.items[id])


func _on_ActivityView_show_list():
	$ActivityList.build_list()
	$ActivityView.hide()


func _on_Info_show_list():
	$Info.hide()
	$ActivityList.show()


func _on_ActivityList_info_pressed():
	$ActivityList.hide()
	$Info.show()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
