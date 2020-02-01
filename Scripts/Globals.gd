extends Node

# Player Variables
var MAX_HEALTH = 100
var MAX_SHEILD = 50
var MAX_VELOCITY_SPEED = 3.0
var MAX_ROTATION_SPEED = 10.0

# Dampening Variables
var VELOCITY_DAMPENING = .99
var SPEED_DAMPENING = .99
var ROTATION_DAMPENING = .95

# Ship Player Particle Variables
var PARTICLE_ACCELERATION_CUTOFF = 0.01
var MAX_PARTICLE_RADIAL_ACCELERATION = 30.0
var MIN_PARTICLE_ACCEL = -20.0

# Scrap Utility variables
var SCRAP_DIR_LIST = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
