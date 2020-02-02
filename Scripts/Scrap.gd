extends Node2D

var rot_speed
var rot_dir
var size
var velocity
var directionMoving
var playerOwned = false
var playerFired = false

# Mouse Variables
var overlapped = false
var dragging = false

var MAX_LIFE_TIME = 5.0
var fireLifeSpan = MAX_LIFE_TIME

#var follow_mouse = false

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
	var image_file_list = get_scrap_images("Resources/Scrap/" + scrap_dir)
	
	var scrap_constructor_dict = {}
	for file in image_file_list:
		if scrap_constructor_dict.has(file[0]):
			scrap_constructor_dict[file[0]].append(file)
		else:
			scrap_constructor_dict[file[0]] = [file]
	generate_scrap_sprite(scrap_dir, get_final_scrap_layers(scrap_constructor_dict))

	
func handle_input():
	if (Input.is_mouse_button_pressed(BUTTON_LEFT) and !playerOwned):
		if(overlapped):
			var parObj = self.get_parent()
			if(parObj.get_name() != "World"):
				self.get_parent().remove_child(self)
				parObj.get_parent().add_child(self)
			overlapped = false
			dragging = true
			playerFired = false
			playerOwned = false
			fireLifeSpan = MAX_LIFE_TIME
	else:
		dragging = false

func _process(delta):
	handle_input()
	if !dragging:
		#print("not_dragging")
		if !playerOwned:
			if playerFired:
				fireLifeSpan -= delta
				if(fireLifeSpan <= 0):
					self.queue_free()
					
			velocity *= Globals.VELOCITY_DAMPENING
			self.set_rotation_degrees(self.get_rotation_degrees() + rot_speed * delta * rot_dir)
			self.set_position(self.get_position() + directionMoving)
	elif !playerOwned:
		self.set_position(get_global_mouse_position())

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
			
		sprite.texture = load("Resources/Scrap/" + scrap_dir + "/" + layer)
		sprite.scale = Vector2(size, size)
		self.add_child(sprite)

func get_value():
	return size * 10
	
#Check in range to point, within clamp_range
func is_inrange(pointToCheck):
	var dist = get_global_position().distance_to(pointToCheck)
	if(dist < Globals.SCRAP_TRACTOR_DIST_CLAMP_RANGE):
		return true
	return false
	
# Modifys the junk floating by the direction being pulled and the increase in velocity towards that direction
func tractor_junk(pointToGetTo, delta):
	if(velocity < Globals.MAX_TRACTOR_VELOCITY):
		velocity += delta * Globals.MAX_TRACTOR_VELOCITY
		
	var dirToDest = get_global_position().direction_to(pointToGetTo)
	#print("Pos to get to: ", pointToGetTo)
	#print("this globalPos: ",get_global_position())
	#print("dir To: ",dirToDest)
	directionMoving += dirToDest * velocity

func set_playerOwned():
	fireLifeSpan = MAX_LIFE_TIME
	playerOwned = true
	playerFired = false
	directionMoving = Vector2(0, 0)
	
func is_dragged():
	return dragging
	
func is_playerOwned():
	return playerOwned
	
func is_playerFired():
	return playerFired
	
func fire_trash(direction):
	playerOwned = false
	playerFired = true
	directionMoving = direction * Globals.PLAYER_PROJECTILE_SPEED

func _on_Area2D_mouse_entered():
	if(!dragging and !playerOwned):
		overlapped = true

func _on_Area2D_mouse_exited():
	overlapped = false
