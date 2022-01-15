extends Resource

class_name Activity

# start_time is used to calculate the elapsed time
export var start_time = 0
export var history = []
export var title = ""
export var notes = ""
export(Color, RGB) var color_code = Color.green

var node

func stopped():
	# Stopped if we have an even number of timestamps
	return history.size() % 2 == 0


func get_last_stop_time():
	var t = 0
	var s = history.size()
	if s > 1: # There is a recorded stop time
		if s % 2 == 0:
			t = history[s - 1]
		else:
			t = history[s - 2]
	return t


func get_last_start_time():
	var t = 0
	var s = history.size()
	if s > 0: # There is a recorded start time
		if s % 2 == 0:
			t = history[s - 2]
		else:
			t = history[s - 1]
	return t


func add_timestamp():
	var t = Data.get_time_secs()
	if start_time == 0:
		start_time = t
	elif stopped():
		# Restarting after a pause
		start_time += t - history[-1]
	history.append(t)


func reset():
	if stopped():
		# See add_timestamp() function for why this is needed 
		start_time = history[-1]
	else:
		start_time = Data.get_time_secs()


func get_elapsed_time():
	if start_time == 0:
		return 0
	elif stopped():
		return history[-1] - start_time
	else:
		return Data.get_time_secs() - start_time
