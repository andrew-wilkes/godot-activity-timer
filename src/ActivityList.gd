extends VBoxContainer

signal view_clicked(id)

var bar_scene = preload("res://ActivityBar.tscn")
var drag_item

func _ready():
	pass


func _on_Add_pressed():
	var act = Activity.new()
	act.node = bar_scene.instance()
	add_child_below_node($Menu, act.node, true)
	act.node.connect("start_request", self, "start_timer")
	act.node.connect("stop_request", self, "stop_timer")
	act.node.connect("view_request", self, "view_timer")
	act.node.connect("drag_drop_request", self, "bar_clicked")
	act.node.id = Data.activities.get_id(act)
	act.new = true
	# Allow time for node to be visible
	yield(get_tree(), "idle_frame")
	check_if_space_to_add_new_bar()


func check_if_space_to_add_new_bar():
	var num_bars = get_child_count() - 1
	if num_bars > 0:
		var base = get_child(num_bars)
		var sep = get("custom_constants/separation")
		# Account for the extra margin y sizes set in main.gd = 50
		var limit = OS.get_window_safe_area().size.y - 50.0 - sep - base.rect_size.y 
		if base.margin_bottom > limit:
			$Menu/Add.visible = false
		else:
			$Menu/Add.visible = true


func bar_clicked(item, pressed):
	if pressed:
		drag_item = item
		# Track mouse y position
	else:
		# Drop
		# Reparent bar
		drag_item = null


func start_timer(item):
	Data.activities.items[item.id].stopped = false


func stop_timer(item):
	Data.activities.items[item.id].stopped = true


func view_timer(id):
	emit_signal("view_clicked", id)
