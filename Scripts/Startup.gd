extends Node

func _ready():
	generate_scrap_dictionary("res://Resources/Scrap")

func generate_scrap_dictionary(path):
	var dir = Directory.new()
	
	var scrap_list = []
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if dir.current_is_dir():
				if file_name != "." and file_name != "..":
					scrap_list.append(file_name)
					print("Found directory: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	print(scrap_list)
	Globals.SCRAP_DIR_LIST = scrap_list
