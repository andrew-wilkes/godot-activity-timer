extends ColorRect

var thirty_days

func _ready():
	rect_size.y = rect_min_size.y
	thirty_days = 30 * 24 * 3600
	var samples = test_sampler()
	#test_create_data_texture()
	var texture = create_data_texture(get_texture_bytes_from_samples(samples))
	material.set_shader_param("data", texture)


func show_line(data: Array):
	# Span of 30 days
	var _samples: Array
	if data.size() > 0:
		_samples = get_samples(data)
	print("DONE")


func get_texture_bytes_from_samples(samples: Array):
	var rgb_bytes = PoolByteArray([])
	print(samples)
	var m = samples.max() * 1.1
	for s in samples:
		var v = 255.0 * s / m
		rgb_bytes.append_array([v, v, v])
	return rgb_bytes


func create_data_texture(data: PoolByteArray):
	var img = Image.new()
	img.create_from_data(720, 1, false, Image.FORMAT_RGB8, data)
	var texture = ImageTexture.new()
	texture.create_from_image(img)
	return texture


func get_samples(data: Array):
	var now = Data.get_time_secs()
	var t = now - thirty_days
	var sample_size = 3600 # 1 hour
	var idx = 0
	var sampling = true
	var active = false
	var t1
	var samples = []
	var total = 0
	while sampling and t < now:
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
	while t < now:
		t = t + sample_size
		if active:
			total = sample_size
		else:
			total = 0
		samples.append(total)
	return samples


func test_sampler():
	var now = Data.get_time_secs()
	var t = now - thirty_days
	var one_day = 24 * 3600
	var data = [t, t + 60, t + 3665, t + 3765, t + one_day, t + 2 * one_day]
	var samples = get_samples(data)
	return samples


func test_create_data_texture():
	# Create a gray-scale gradient image and set it to the shader data input
	var data = PoolByteArray([])
	for n in 720:
		var v = n / 720.0 * 255.0
		data.append_array([v, v, v])
	var texture = create_data_texture(data)
	material.set_shader_param("data", texture)
