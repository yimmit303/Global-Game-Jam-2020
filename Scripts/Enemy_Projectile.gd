extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Vector2) var velocity;
var life = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	self.rotate(self.velocity.angle())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position += velocity * delta;
	life -= delta;
	if life <= 0:
		self.queue_free();


func _exit_tree():
	pass;


func get_damage():
	self.queue_free();
	return 5;
