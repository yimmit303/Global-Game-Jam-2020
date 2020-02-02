extends Node2D


func play_sound(sound : String):
	get_node(sound).play()

func play_looping_sound(sound : String):
	get_node(sound).playing = true

func stop_looping_sound(sound : String):
	get_node(sound).playing = false
