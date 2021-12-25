extends Resource

class_name Activity

export var start_time = 0
export var stop_time = 0
export var time = 0
export var title = ""
export var notes = ""
export(Color, RGB) var color_code = Color.green

var stopped = true
var node
var new = false
