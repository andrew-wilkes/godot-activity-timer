extends ColorRect

var thirty_days

func _ready():
	rect_size.y = rect_min_size.y
	thirty_days = 30 * 24 * 3600 # Seconds
	#test_impulses()
	#apply_data([])
	#print(clean_data([3,2,4,30,20]))
	#test_sampler(2)
	#test_create_data_texture()


func apply_data(timestamp_history: Array):
	var data = clean_data(timestamp_history)
	var samples: Array
	samples = get_samples(data)
	var bytes = get_texture_bytes_from_samples(samples)
	var texture = create_data_texture(bytes)
	material.set_shader_param("data", texture)
	return data


# Scale the sample values to fit in the range 0 - 255
func get_texture_bytes_from_samples(samples: Array):
	var bytes = PoolByteArray([])
	var m = samples.max()
	var normalization_factor = max(1.0, m)
	for s in samples:
		var v = int(255 * s / normalization_factor)
		# Make recent activity visible
		if s > 0 and v < 4:
			v = 4 # Min value to be visible
		bytes.append(v)
	return bytes


# We supply bytes of data (0 - 255) to form a data.size() x 1 pixel image
func create_data_texture(data: PoolByteArray):
	var img = Image.new()
	img.create_from_data(data.size(), 1, false, Image.FORMAT_R8, data) # Only use the red component
	var texture = ImageTexture.new()
	texture.create_from_image(img, 0)
	img.save_png("res://temp.png")
	return texture


# A sample size of 3600 is per hour but we get problems resolving full amplitude thin lines
# So we sample per 2 hours and get 360 samples
func get_samples(data: Array):
	var midnight = OS.get_unix_time_from_datetime(OS.get_date()) + 86400
	var t = midnight - thirty_days
	var sample_size = 7200 # 2 hours
	var idx = 0
	var sampling = true if data.size() > 0 else false
	var active = false
	var t1
	var samples = []
	var total = 0
	var now = Data.get_time_secs()
	while sampling and t < midnight:
		total = 0
		t1 = t
		var next_t = t + sample_size
		# Check if timestamp is within this hour
		while data[idx] < next_t and data[idx] >= t:
			if active:
				total += data[idx] - t1
				active = false
			else:
				t1 = data[idx]
				active = true
			idx += 1
			if idx == data.size():
				sampling = false
				break
		if active:
			if next_t > now:
				total += now - t1
				active = false
			else:
				total += next_t - t1
		samples.append(total)
		t = next_t
	# There are no more time stamps now
	# If active, want to accumulate time until the present time
	while t < midnight:
		var next_t = t + sample_size
		if active:
			if next_t > now:
				total = now - t
				active = false
			else:
				total = sample_size
		else:
			total = 0
		samples.append(total)
		t = next_t
	return samples


func clean_data(data: Array):
	# Time stamps must be sequential
	var last_value = 0
	for t in data.duplicate():
		if t <= last_value:
			data.erase(t)
		last_value = t
	return data


func get_test_data(idx):
	var zero_oclock = OS.get_unix_time_from_datetime(OS.get_date())
	var hour: int = 3600
	var day: int = 24 * hour
	var t: int = zero_oclock - day * 29
	var _now = Data.get_time_secs()
	var data = [
# warning-ignore:integer_division
		[t, t + 2, t + 4, t + hour / 2, t + 2 * hour, t + 4 * hour], # > [1798, 0, 3600, 3600, 0, 0 ...
# warning-ignore:integer_division
# warning-ignore:integer_division
		[zero_oclock - hour / 2, zero_oclock + hour / 2], # > ... 0, 0, 1800, 1800, 0, 0 ...] @ index 695, 696 on page 34
		[zero_oclock + hour], # > up to now ... 0, 0, 3600, 3600, < 3600, 0, 0 ...]
		[1640800840, 1640805840],
		[1640800840, 1640805840, 1640944913],
		[1640800840, 1640805840, 1640944913, 1640945012]
	]
	return data[idx]


func test_sampler(idx):
	var samples = get_samples(get_test_data(idx))
	return samples


func test_create_data_texture():
	# Create a gray-scale gradient image and set it to the shader data input
	var data = PoolByteArray([])
	for n in 720:
		var v = n / 720.0 * 255.0
		data.append(v)
	var texture = create_data_texture(data)
	material.set_shader_param("data", texture)


func test_impulses():
	var data = PoolByteArray([])
	for n in 720:
		if n % 20 < int(n / 64):
			data.append(255)
		else:
			data.append(0)
	var texture = create_data_texture(data)
	material.set_shader_param("data", texture)
