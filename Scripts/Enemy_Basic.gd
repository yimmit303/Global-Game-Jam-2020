extends Node2D

#Values intended for logic
export(NodePath) var goal;
var target: Node2D
var target_position;
var state = "acquiring";
var states = ["acquiring", "persuing", "attacking"]; #Not actually used, just here for convenience

#Fixed Values for movement
var outer_diameter = 500;
var inner_diameter = 300;
var attack_speed: float = 400;
var rotate_speed: float = 2
var acceleration: float = 200;

#Values for constant manipulation
var cooldown: float = 0;
var velocity = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(goal)
	pass # Replace with function body.



func acquire(var delta):
	#Get direction of player
	var angle = self.get_angle_to(target.global_position);
	if angle < 0:
		self.rotate(-delta * rotate_speed);
	elif angle > 0:
		self.rotate(delta * rotate_speed);
		
	angle = self.get_angle_to(target.global_position);
	if abs(angle) < .05:
		self.state = "pursuing";



func pursue(var delta):
	var distance_to_target = (target.global_position - self.global_position).length() - 300;
	if self.velocity < attack_speed:
		self.velocity += delta * acceleration;
	self.position += self.global_transform.x * self.velocity * delta;
	return true;



func attack(var delta):
	return true;
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	cooldown -= 1 * delta;
	
	if state == "acquiring":
		acquire(delta);
		
	elif state == "pursuing":
		pursue(delta);
		
	elif state == "attacking":
		attack(delta);