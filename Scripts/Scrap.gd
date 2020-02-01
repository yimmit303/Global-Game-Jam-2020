extends Node2D

var rot_speed
var rot_dir
var size
var velocity
var directionMoving
var playerOwned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	size = (randf() + 1)
	rot_speed = randi() % 180
	var dir_list = [-1, 1]
	dir_list.shuffle()
	rot_dir = dir_list[0]
	
	velocity = randf()
	directionMoving = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	
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


func _process(delta):
	velocity *= Globals.VELOCITY_DAMPENING
	self.set_rotation_degrees(self.get_rotation_degrees() + rot_speed * delta * rot_dir)
	self.set_position(self.get_position() + directionMoving * delta)

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

func get_value():
	return size * 10
	
#Check in range to point, within clamp_range
func is_inrange(pointToCheck):
	var dist = pointToCheck - self.position
	if(dist.x < Globals.SCRAP_TRACTOR_DIST_CLAMP_RANGE + self.size.x and dist.y < Globals.SCRAP_TRACTOR_DIST_CLAMP_RANGE + self.size.y):
		return true
	return false
	
# Modifys the junk floating by the direction being pulled and the increase in velocity towards that direction
func tractor_junk(pointToGetTo, delta):
	if(velocity < Globals.MAX_VELOCITY_SPEED):
		velocity += delta * Globals.MAX_VELOCITY_SPEED
		
	var dirToDest = (self.position - pointToGetTo).normalized()	
	directionMoving += dirToDest * velocity

func set_playerOwned():
	playerOwned = true
	directionMoving = Vector2(0, 0)
	
func is_playerOwned():
	return playerOwned
	
func fire_trash(direction):
	directionMoving = direction * Globals.PLAYER_PROJECTILE_SPEED
