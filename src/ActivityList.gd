extends VBoxContainer

signal view_clicked(id)

var bar_scene = preload("res://ActivityBar.tscn")
var drag_item
var current_item_index
var y_offset
var row_height
var top_margin = 0

func _ready():
	build_list()


func clear_list():
	hide()
	for idx in get_child_count():
		if idx > 0:
			get_child(idx).queue_free()


func build_list():
	show()
	for id in Data.activities.order:
		var act = Data.activities.items[id]
		act.node = bar_scene.instance()
		act.node.id = id
		act.node.setup(act)
		add_child(act.node)
		connect_bar(act.node)
		yield(get_tree(), "idle_frame")
		check_if_space_to_add_new_bar()


func _on_Add_pressed():
	var act = Activity.new()
	act.node = bar_scene.instance()
	add_child_below_node($Menu, act.node, true)
	connect_bar(act.node)
	act.node.id = Data.activities.get_id_and_add_to_data(act)
	act.node.setup(act)
	act.new = true
	# Allow time for node to be visible
	yield(get_tree(), "idle_frame")
	check_if_space_to_add_new_bar()
	view_activity(act.node.id)


func connect_bar(node):
	node.connect("view_request", self, "view_activity")
	node.connect("drag_drop_request", self, "bar_clicked")


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
	var mpos = get_viewport().get_mouse_position().y
	row_height = get_child(1).rect_size.y + get("custom_constants/separation")
	current_item_index = get_item_index_from_viewport_position(mpos)
	if pressed:
		drag_item = item
		# Offset of mouse to bar rect_position.y
		y_offset = fmod(mpos - 140 - top_margin, row_height) + top_margin
	else:
		# Drop
		drag_item.rect_position.y = 140 + row_height * current_item_index
		drag_item = null


func get_item_index_from_viewport_position(y_pos: float):
	var id = (y_pos - 140 - top_margin) / row_height
	id = clamp(id, 0, get_child_count() - 2)
	return int(id)


func view_activity(id):
	emit_signal("view_clicked", id)


func _input(event):
	if event is InputEventMouseMotion:
		if drag_item != null:
			var item_index = get_item_index_from_viewport_position(event.position.y)
			if item_index != current_item_index:
				move_child(drag_item, item_index + 1)
				current_item_index = item_index
			drag_item.rect_position.y = event.position.y - y_offset
