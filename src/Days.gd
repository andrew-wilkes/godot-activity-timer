extends HBoxContainer

func _ready():
	for n in 29:
		var day = $Day.duplicate()
		day.text = str(n + 2)
		add_child(day)


func update_days():
	var t = OS.get_unix_time_from_datetime(OS.get_date()) - 29 * 24 * 3600 # 29 days before
	for n in get_child_count():
		get_child(n).text = str(OS.get_datetime_from_unix_time(t).day)
		t += 86400
