extends ColorRect

var thirty_days

func _ready():
	rect_size.y = rect_min_size.y
	thirty_days = 30 * 24 * 3600 # Seconds
	#test_impulses()
	#apply_data(get_test_data())
	#apply_data([])
	#print(clean_data([3,2,4,30,20]))


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
		var v = 255 * s / normalization_factor
		bytes.append(v)
	return bytes


# We supply bytes of data (0 - 255) to form a data.size() x 1 pixel image
func create_data_texture(data: PoolByteArray):
	var img = Image.new()
	img.create_from_data(data.size(), 1, false, Image.FORMAT_R8, data) # Only use the red component
	var texture = ImageTexture.new()
	texture.create_from_image(img, 0)
	return texture


# Samples are an array of 720 slots containing the number of active seconds per hour
# There are 720 hours in 30 days
# The data will be used in an image 720 pixels wide
func get_samples(data: Array):
	var midnight = OS.get_unix_time_from_datetime(OS.get_date()) + 86400
	var t = midnight - thirty_days
	var sample_size = 3600 # 1 hour
	var idx = 0
	var sampling = true if data.size() > 0 else false
	var active = false
	var t1
	var samples = []
	var total = 0
	while sampling and t < midnight:
		total = 0
		t1 = t
		var next_t = t + sample_size
		while data[idx] < next_t:
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
			total = next_t - t1
		samples.append(total)
		t = next_t
	var now = Data.get_time_secs()
	while t < midnight:
		t = t + sample_size
		if active and t < now:
			total = sample_size
		else:
			total = 0
		samples.append(total)
	return samples


func clean_data(data: Array):
	# Time stamps must be sequential
	var last_value = 0
	for t in data.duplicate():
		if t <= last_value:
			data.erase(t)
		last_value = t
	return data


func get_test_data():
	var zero_oclock = OS.get_unix_time_from_datetime(OS.get_date())
	var one_day = 24 * 3600
	var t = zero_oclock - one_day * 29
	var now = Data.get_time_secs()
	return [t, t + 1800, t + 3665, t + 3765, t + one_day, t + 2.5 * one_day, now - 2 * one_day - 6000, now - 2 * one_day]


func test_sampler():
	var samples = get_samples(get_test_data())
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
		if n % 100 < 8:
			data.append(255)
		else:
			data.append(0)
	var texture = create_data_texture(data)
	material.set_shader_param("data", texture)
