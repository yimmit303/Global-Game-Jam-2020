extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Vector2) var velocity;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position += velocity * delta;


func get_damage():
	self.queue_free();
	return 5;