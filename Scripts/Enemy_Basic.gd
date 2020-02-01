extends Node2D

#Values intended for logic
export(NodePath) var goal;
var target: Node2D
var target_position;
var state = "acquiring";
var states = ["acquiring", "persuing", "attacking"]; #Not actually used, just here for convenience
var projectile_prefab = load("res://Scenes//Enemy_Projectile.tscn");

#Fixed Values for movement
var outer_diameter = 500;
var inner_diameter = 300;
var attack_speed: float = 2000;
var rotate_speed: float = 1
var acceleration: float = 250;
var decelleration_modifier = 2;

#Values for constant manipulation
var cooldown: float = 0;
var cdown_short = 0;
var velocity = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(goal)
	pass # Replace with function body.



func fire_projectile(var cdown = .5) -> bool:
	if self.cooldown > 0:
		return false;
	var proj = projectile_prefab.instance();
	proj.position = self.position;
	proj.velocity = (self.global_transform.x * (self.velocity + 300));
	self.get_parent().add_child(proj);
	self.cooldown = cdown;
	return true;



func acquire(var delta):
	#Get direction of player
	var angle = self.get_angle_to(target.global_position);
	if angle < 0:
		self.rotate(-delta * rotate_speed);
	elif angle > 0:
		self.rotate(delta * rotate_speed);
		
	angle = self.get_angle_to(target.global_position);
	self.position += self.global_transform.x * self.velocity * delta;
	if abs(angle) < .05:
		self.state = "pursuing";



func pursue(var delta):
	var distance_to_target = (target.global_position - self.global_position).length() - self.inner_diameter;
	
	if distance_to_target < 0:
		self.state = "attacking";
		return;
		
	#Get direction of player for course corrections
	var angle = self.get_angle_to(target.global_position);
	
	if abs(angle) > .25:
		self.state = "acquiring";
		return;
	
	if angle < 0 and angle < delta * rotate_speed:
		self.rotate(-delta * rotate_speed);
	elif angle > 0 and angle > delta * rotate_speed:
		self.rotate(delta * rotate_speed);
	
	var low_velocity = sqrt(self.acceleration * distance_to_target / 2) * self.decelleration_modifier;
	
	if self.velocity < attack_speed and self.velocity < low_velocity:
		self.velocity += delta * acceleration;
	elif self.velocity > low_velocity and self.velocity > 0:
		self.velocity -= delta * acceleration * self.decelleration_modifier;
		
	self.position += self.global_transform.x * self.velocity * delta;
	
	if abs(angle) < .2 and distance_to_target < 600:
		if cdown_short == 0:
			if fire_projectile(.15):
				cdown_short = 1;
		elif cdown_short == 1:
			if fire_projectile(.15):
				cdown_short = 2;
		elif cdown_short == 2:
			if fire_projectile(.75):
				cdown_short = 0;



func attack(var delta):
	#Get direction of player
	
	var distance_to_target = (target.global_position - self.global_position).length();
	if distance_to_target > self.outer_diameter:
		self.state = "acquiring";
		return;
	
	var angle = self.get_angle_to(target.global_position);
	if angle < 0 and angle < delta * rotate_speed:
		self.rotate(-delta * rotate_speed);
	elif angle > 0 and angle > delta * rotate_speed:
		self.rotate(delta * rotate_speed);
		
	angle = self.get_angle_to(target.global_position);
	
	if abs(angle) < .2:
		if cdown_short == 0:
			if fire_projectile(.15):
				cdown_short = 1;
		elif cdown_short == 1:
			if fire_projectile(.15):
				cdown_short = 2;
		elif cdown_short == 2:
			if fire_projectile(.75):
				cdown_short = 0;
	
	

func _exit_tree():
	pass;



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	cooldown -= 1 * delta;
	
	if state == "acquiring":
		acquire(delta);
		
	elif state == "pursuing":
		pursue(delta);
		
	elif state == "attacking":
		attack(delta);
