extends Node2D

export(NodePath) var goal;
var state = "acquiring";
var states = ["acquiring", "persuing", "attacking"];
var outer_diameter = 500;
var inner_diameter = 300;
var attack_speed: float = 20;
var cooldown: float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func acquire(var delta) -> bool:
	#Get direction of player
	var player_vec: Vector2 = self.global_position - goal.global_position;
	player_vec = player_vec.normalized()
	var enemy_heading = Vector2(cos(self.rotation_degrees), sin(self.rotation_degrees));
	var dir = player_vec.dot(enemy_heading)
	if dir < 0:
		self.rotate(delta);
	if dir > 0:
		self.rotate(delta);
	
	player_vec= self.global_position - goal.global_position;
	player_vec = player_vec.normalized()
	enemy_heading = Vector2(cos(self.rotation_degrees), sin(self.rotation_degrees));
	dir = player_vec.dot(enemy_heading)
	if dir * dir < .1:
		return true;
	else:
		return false;
	
func pursue() -> bool:
	return true;
	
func attack() -> bool:
	return true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	cooldown -= 1 * delta;
	
	if state == "acquiring":
		if acquire(delta) == true:
			state = "pursuing";
		
	elif state == "persuing":
		if pursue() == true:
			state = "attacking";
		
	elif state == "attacking":
		if attack() == true:
			state = "acquiring";
