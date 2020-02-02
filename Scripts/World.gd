extends Node2D


# Declare member variables here. Examples:
var time
var score
var spawnables

onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0
	score = 0
	spawnables = []
	spawnables.append(load("res://Scenes/LightCluster.tscn"))
	spawnables.append(load("res://Scenes/ScrapCluster.tscn"))
	spawnables.append()
	var music = AudioStreamPlayer.new()
	self.add_child(music)
	music.stream = load("res://Resources/Music/SynthTrack-Final200BPMwav.wav")
	music.play()
	pass

func _process(delta):
	var player_direction = player.get_direction()
	
	
	var dir_list = [-1, 1]
	dir_list.shuffle()
	var rot_dir = dir_list[0]
	
	var random_chance = 250
	
	randomize()
	player_direction = player_direction.rotated(deg2rad(rot_dir * randi() % 50))
	if (randi() % random_chance) == 0:
		spawn(spawnables[randi() % len(spawnables)], player.get_position() + player_direction * 1180)
		random_chance += 100
	else:
		random_chance -= 1

func spawn(object, location):
	var new_object = object.instance()
	new_object.set_position(location)
	if new_object.has_method("set_player_ref"):
		new_object.set_rotation_degrees(randi() % 360)
		new_object.set_player_ref(player)
	self.add_child(new_object)

func add_score(in_score):
	score += in_score

func get_audio_manager():
	return get_node("../AudioManager")

func player_died():
	get_node("../EndScreen").visible = true
	get_node("../EndScreen/Label").text += str(score)
	get_tree().paused = true
