extends Container

func _ready():
	var ws = OS.get_window_safe_area()
	var top_margin = ws.position.y + 40.0
	$ActivityList.top_margin = top_margin
	set("custom_constants/margin_top", top_margin)
	set("custom_constants/margin_bottom", ws.end.y + 10.0)


func _on_ActivityList_view_clicked(id):
	$ActivityList.clear_list()
	$ActivityView.setup(id, Data.activities.items[id])


func _on_ActivityView_show_list():
	$ActivityList.build_list()
	$ActivityView.hide()


func _on_Timer_timeout():
	for a in Data.activities.items.values():
		var act: Activity = a
		if not act.stopped:
			act.time += 1
