extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if Input.is_action_just_pressed("gravity_beam"):
		load("res://Scripts/CameraShake.gd").shake_camera(get_node("../CanvasLayer/Player/Camera2D"), 1.0)
