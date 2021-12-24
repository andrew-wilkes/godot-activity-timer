extends VBoxContainer

var bar_scene = preload("res://ActivityBar.tscn")

func _ready():
	pass


func _on_Add_pressed():
	var act = Activity.new()
	act.node = bar_scene.instance()
	add_child_below_node($Menu, act.node, true)
	yield(get_tree(), "idle_frame")
	check_if_space_to_add_new_bar()


func check_if_space_to_add_new_bar():
	var num_bars = get_child_count() - 1
	if num_bars > 0:
		var base = get_child(num_bars)
		var sep = get("custom_constants/separation")
		var limit = OS.get_window_safe_area().size.y - 30.0 - sep - base.rect_size.y 
		if base.margin_bottom > limit:
			$Menu/Add.visible = false
		else:
			$Menu/Add.visible = true
