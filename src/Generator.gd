extends Control

var act_names = ["Reading", "Running", "Study", "Sleeping", "Playing games", "Reviewing finances", "Driving", "Watching videos", "On social media", "Coding"]

var ipsum = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.", "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."]

var thirty_days
var now
var zero
var day

func _ready():
	day = 24 * 3600
	thirty_days = 30 * day
	now = Data.get_time_secs()
	zero = OS.get_unix_time_from_datetime(OS.get_date())
	var activities = Activities.new()
	var id = 0
	for act_name in act_names:
		var act = Activity.new()
		act.history = []
		act.title = act_name
		test7(act)
		act.notes = PoolStringArray(ipsum.slice(0, randi() % ipsum.size())).join("\n")
		activities.order.append(id)
		activities.items[id] = act
		id += 1
		activities.next_id = id
		#break
	Data.save_data(activities, Data.ACTIVITIES_FILE_NAME)

func test7(act: Activity):
	var t: int = now - thirty_days
	while t < now:
		act.history.append(t)
		t += randi() % (4 * day)
	if act.stopped():
		act.start_time = act.history[-2]
	else:
		act.start_time = act.history[-1]

func test6(act: Activity):
	act.history.append(zero - thirty_days)
	act.history.append(zero - 20 * day)
	act.history.append(zero - 19 * day)
	act.history.append(zero - 18 * day)
	act.start_time = zero - 18 * day

func test5(act: Activity):
	act.history.append(zero - thirty_days - thirty_days)
	act.history.append(zero - thirty_days - day)
	act.history.append(zero - thirty_days)
	act.start_time = zero - thirty_days

func test4(act: Activity):
	act.history.append(zero - thirty_days - day)
	act.history.append(zero - thirty_days)
	act.start_time = 0

func test3(act: Activity):
	act.history.append(zero - thirty_days - day)
	act.history.append(zero - day)
	act.start_time = 0

func test2(act: Activity):
	act.history.append(zero - day)
	act.start_time = zero - day

func test1(act: Activity):
	act.history.append(zero)
	act.start_time = zero
