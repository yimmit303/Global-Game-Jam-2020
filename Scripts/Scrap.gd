extends Node2D

var rot_speed
var rot_dir
var size

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	size = (randf() + 1)
	rot_speed = randi() % 180
	var dir_list = [-1, 1]
	dir_list.shuffle()
	rot_dir = dir_list[0]
	
	var rand_index = randi() % Globals.SCRAP_DIR_LIST.size()
	var scrap_dir = Globals.SCRAP_DIR_LIST[rand_index]
	var image_file_list = get_scrap_images("res://Resources/Scrap/" + scrap_dir)
	
	var scrap_constructor_dict = {}
	for file in image_file_list:
		if scrap_constructor_dict.has(file[0]):
			scrap_constructor_dict[file[0]].append(file)
		else:
			scrap_constructor_dict[file[0]] = [file]
	generate_scrap_sprite(scrap_dir, get_final_scrap_layers(scrap_constructor_dict))

func _input(event):
	if Input.is_action_just_pressed("gravity_beam"):
		get_tree().reload_current_scene()

func _process(delta):
	self.set_rotation_degrees(self.get_rotation_degrees() + rot_speed * delta * rot_dir)

func get_scrap_images(path):
	var dir = Directory.new()
	
	var file_list = []
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if !dir.current_is_dir():
				if file_name.ends_with(".png"):
					file_list.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return file_list

func get_final_scrap_layers(constructor_dict):
	var layer_files = []
	for i in constructor_dict.keys():
		
		if len(constructor_dict[i]) > 1:
			layer_files.append(constructor_dict[i][randi() % len(constructor_dict[i])])
		else:
			layer_files.append(constructor_dict[i][0])
	return layer_files

func generate_scrap_sprite(scrap_dir, scrap_layers):
	randomize()
	for layer in scrap_layers:
		var sprite = Sprite.new()
		if layer.count("_C_") > 0:
			sprite.set_modulate(Color.from_hsv(randf(), (randf() * 0.3 + 0.3), 0.74, 1))
		sprite.texture = load("res://Resources/Scrap/" + scrap_dir + "/" + layer)
		sprite.scale = Vector2(size, size)
		self.add_child(sprite)