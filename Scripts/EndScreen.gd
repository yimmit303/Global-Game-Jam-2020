extends ColorRect

onready var timer = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.visible:
		timer -= delta
		if timer <= 0:
			self.get_tree().reload_current_scene()
