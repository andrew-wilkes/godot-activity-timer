extends Node

const SETTINGS_FILE_NAME = "user://settings.res"

var settings: Settings
var settings_changed = false
var activities

func _ready():
	load_settings()


func load_settings(file_name = SETTINGS_FILE_NAME):
	settings = Settings.new()
	if ResourceLoader.exists(file_name):
		var data = ResourceLoader.load(file_name)
		if data is Settings: # Check that the data is valid
			settings = data


func get_file_content(path) -> String:
	var content = ""
	var file = File.new()
	if file.open(path, File.READ) == OK:
		content = file.get_as_text()
		file.close()
	return content


func save_settings(_settings, file_name = SETTINGS_FILE_NAME):
	assert(ResourceSaver.save(file_name, _settings) == OK)
	settings_changed = false


func save_string(content, file_name):
	var file = File.new()
	var error = file.open(file_name, File.WRITE)
	file.store_string(content)
	file.close()
	return error


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if settings_changed:
			save_settings(settings)
