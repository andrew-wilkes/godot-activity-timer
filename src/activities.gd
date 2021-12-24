extends Resource

class_name Activities

export(int) var next_id = 0
export var items = {}
export var order = []

func get_id(new_activity: Activity):
	var id = next_id
	next_id += 1
	items[id] = new_activity
	order.push_front(id)
	return id
