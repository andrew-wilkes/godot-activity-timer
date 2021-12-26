extends VBoxContainer

signal view_clicked(id)

var bar_scene = preload("res://ActivityBar.tscn")
var drag_item

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
	if pressed:
		drag_item = item
		# Track mouse y position
	else:
		# Drop
		# Reparent bar
		drag_item = null


func view_activity(id):
	emit_signal("view_clicked", id)
