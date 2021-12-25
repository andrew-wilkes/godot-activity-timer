extends PopupPanel

signal confirmed

func _ready():
	# Shrink to fit content
	rect_size = Vector2.ZERO


func _on_Cancel_pressed():
	hide()


func _on_OK_pressed():
	hide()
	emit_signal("confirmed")
