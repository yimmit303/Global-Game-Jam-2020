extends Node2D


# Declare member variables here. Examples:
var time
var score
var spawnables

onready var player = $Foreground/Player

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0
	score = 0
	spawnables = []
	spawnables.append(load("res://Scenes/LightCluster.tscn"))
	spawnables.append(load("res://Scenes/ScrapCluster.tscn"))
	
	pass

func _process(delta):
	var player_direction = player.get_direction()
	
	var dir_list = [-1, 1]
	dir_list.shuffle()
	var rot_dir = dir_list[0]
	
	randomize()
	player_direction = player_direction.rotated(deg2rad(rot_dir * randi() % 50))
	if (randi() % 500) == 0:
		spawn(spawnables[randi() % len(spawnables)], player.get_position() + player_direction * 1180)
		print($Foreground.get_children())

func spawn(object, location):
	var new_object = object.instance()
	new_object.set_position(location)
	if new_object.has_method("set_player_ref"):
		new_object.set_rotation_degrees(randi() % 360)
		new_object.set_player_ref(player)
	$Foreground.add_child(new_object)
	

func _input(event):
	if Input.is_action_just_pressed("gravity_beam"):
		load("res://Scripts/CameraShake.gd").shake_camera(player.get_camera(), 1.0)

func add_score(in_score):
	score += in_score
