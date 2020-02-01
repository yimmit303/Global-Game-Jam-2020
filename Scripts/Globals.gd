extends Node

# Player Variables
var MAX_HEALTH = 100
var MAX_SHEILD = 50
var MAX_VELOCITY_SPEED = 3.0
var MAX_ROTATION_SPEED = 10.0
var PLAYER_PROJECTILE_SPEED = 4.0

# Dampening Variables
var VELOCITY_DAMPENING = .95
var SPEED_DAMPENING = .99
var ROTATION_DAMPENING = .95
var VELOCITY_CUTTOFF = .01

var SCRAP_TRACTOR_DIST_CLAMP_RANGE = 0.2

# Ship Player Particle Variables
var MAX_PARTICLES = 128

# Scrap Utility variables
var SCRAP_DIR_LIST = []

# Converts Degrees to radians
func to_rad(degrees):
	return degrees * PI/180

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
