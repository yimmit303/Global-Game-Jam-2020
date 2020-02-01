extends Node

func _ready():
	generate_scrap_dictionary("res://Resources/Scrap")

func generate_scrap_dictionary(path):
	var dir = Directory.new()
	
	var scrap_dict = {}
	var count = 0
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if dir.current_is_dir():
				if file_name != "." and file_name != "..":
					scrap_dict[count] = file_name
					count += 1
					print("Found directory: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	print(scrap_dict)
	Globals.SCRAP_DICTIONARY = scrap_dict
