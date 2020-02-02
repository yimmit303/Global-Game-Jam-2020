extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.visible:
		yield(self.get_tree().create_timer(5.0),"timeout")
		self.get_tree().reload_current_scene()
