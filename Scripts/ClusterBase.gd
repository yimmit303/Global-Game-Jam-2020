extends Node

var player_ref

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if (self.position - player_ref.position).length() > 1300:
		self.queue_free()

func set_player_ref(player):
	player_ref = player
