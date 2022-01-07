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


func alert(txt):
	set_label_text(txt)
	popup_centered()


func set_label_text(txt):
	$VBox/Label.text = txt
