extends HBoxContainer

signal start_request(this)
signal stop_request(this)
signal view_request(id)
signal drag_drop_request(this, pressed)

var id
var running = false
var dragging = false

func _ready():
	if get_parent().name == "root":
		# Test
		$Title.text = "33s"
		update_time(33)
		yield(get_tree().create_timer(2.0), "timeout")
		$Title.text = "10 minutes and 10s"
		update_time(610)
		yield(get_tree().create_timer(2.0), "timeout")
		$Title.text = "10 hours 10 mins and 10s"
		update_time(36610)


func _on_StartStop_pressed():
	if running:
		$StartStop.text = "Start"
		emit_signal("stop_request", self)
	else:
		$StartStop.text = "Stop"
		emit_signal("start_request", self)


func _on_View_pressed():
	emit_signal("view_request", id)


func _on_Title_toggled(button_pressed):
	emit_signal("drag_drop_request", self, button_pressed)


func update_time(secs):
	if secs < 6000:
		$Time.text = "%02d:%02d" % [secs / 60, secs % 60]
	else:
		$Time.text = "%02d:%02d:%02d" % [secs / 3600, secs % 3600 / 60, secs % 60]
