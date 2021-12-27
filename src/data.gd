extends Node

const SETTINGS_FILE_NAME = "user://settings.res"
const ACTIVITIES_FILE_NAME = "user://activities.res"

var settings: Settings
var settings_changed = false
var activities: Activities

func _ready():
	var data = load_data(SETTINGS_FILE_NAME)
	if data is Settings: # Check that the data is valid
		settings = data
	else:
		settings = Settings.new()
	data = load_data(ACTIVITIES_FILE_NAME)
	if data is Activities: # Check that the data is valid
		activities = data
	else:
		activities = Activities.new()


func load_data(file_name):
	if ResourceLoader.exists(file_name):
		return ResourceLoader.load(file_name)


func get_file_content(path) -> String:
	var content = ""
	var file = File.new()
	if file.open(path, File.READ) == OK:
		content = file.get_as_text()
		file.close()
	return content


func save_activities():
	save_data(activities, ACTIVITIES_FILE_NAME)


func save_data(data, file_name):
	assert(ResourceSaver.save(file_name, data) == OK)
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
			save_data(settings, SETTINGS_FILE_NAME)
		save_data(activities, ACTIVITIES_FILE_NAME)


func get_time_secs():
	return OS.get_unix_time_from_datetime(OS.get_time())
