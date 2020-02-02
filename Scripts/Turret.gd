extends Node2D

#Values forgame stuff
var explosion;
var dying = false;
var death_timer = .9;

#Values intended for logic
export(NodePath) var goal;
var target: Node2D
var target_position;
var projectile_prefab = load("res://Scenes//Enemy_Projectile.tscn");
var scrap_prefab = load("res://scenes//ScrapCluster.tscn");

#Fixed Values for movement
var outer_diameter = 1000;
var attack_speed: float = 2000;
var rotate_speed: float = 1.5

#Values for constant manipulation
var cooldown: float = 0;
var cdown_short: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(goal)
	explosion = get_node("ExplosionParticle");
	pass # Replace with function body.



func fire_projectile(var cdown = .5) -> bool:
	if self.cooldown > 0:
		return false;
	var proj = projectile_prefab.instance();
	proj.position = self.position;
	proj.velocity = (self.global_transform.x * (750));
	self.get_parent().add_child(proj);
	self.cooldown = cdown;
	return true;
	
	

func attack(var delta):
	#Get direction of player
	
	var distance_to_target = (target.global_position - self.global_position).length();
	if distance_to_target > self.outer_diameter:
		return;
	
	var angle = self.get_angle_to(target.global_position);
	if angle < 0 and angle < delta * rotate_speed:
		self.rotate(-delta * rotate_speed);
	elif angle > 0 and angle > delta * rotate_speed:
		self.rotate(delta * rotate_speed);
		
	angle = self.get_angle_to(target.global_position);
	
	
	fire_projectile(.75)
	
	

func _exit_tree():
	var cluster = scrap_prefab.instance();
	cluster.global_position = self.global_position;
	cluster.player_ref = self.target;
	self.get_parent().get_parent().add_child(cluster);
	pass;



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not dying:
		cooldown -= 1 * delta;
		attack(delta);
	else:
		self.death_timer -= delta;
		if self.death_timer <= 0:
			self.get_parent().queue_free();
		pass;


func _on_Area2D_area_entered(area):
	if area.get_parent().has_method("get_value"):
		dying = true;
		self.explosion.emitting = true;
	pass # Replace with function body.


func _on_Area2D2_area_entered(area):
	if area.get_parent().has_method("get_value"):
		dying = true;
		self.explosion.emitting = true;
	pass # Replace with function body.
