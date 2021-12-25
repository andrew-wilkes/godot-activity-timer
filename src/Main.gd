extends Container

func _ready():
	var ws = OS.get_window_safe_area()
	set("custom_constants/margin_top", ws.position.y + 40.0)
	set("custom_constants/margin_bottom", ws.end.y + 10.0)


func _on_ActivityList_view_clicked(id):
	$ActivityList.hide()
	$ActivityView.setup(Data.activities.items[id])


func _on_ActivityView_show_list():
	$ActivityList.show()
	$ActivityView.hide()
