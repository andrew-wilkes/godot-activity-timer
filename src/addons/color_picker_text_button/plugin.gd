tool
extends EditorPlugin

const TYPE_NAME = "ColorPickerTextButton"
const SCRIPT = preload("color_picker_text_button.gd")
const ICON = preload("icon.png")

func _enter_tree():
	add_custom_type(TYPE_NAME, "Button", SCRIPT, ICON)


func _exit_tree():
	remove_custom_type(TYPE_NAME)
