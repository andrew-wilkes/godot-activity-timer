extends HBoxContainer

func _ready():
	$M/Activity.hide()


func show_list():
	$M/Activity.hide()
	$M/ActivityList.show()


func _on_Add_pressed():
	pass # Replace with function body.


func _on_Activity_home_button_pressed():
	show_list()
