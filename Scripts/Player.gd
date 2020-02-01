extends Node2D

# Direction Vector and Velocity Vector
var mDirectionFacing = Vector2()
var mDirSpeed = Vector2()

# Velocity of Ship per frame
var mVelocity = 0
var mRotVelocity = 0

# Angle The Ship Sprite is facing in Degrees
var mRotationDir = 270

# Tractor beam variable and objects held
var tractoring = false
var ObjectsTractoring = []
var ObjectsHeld = []

# Converts Degrees to radians
func to_rad(degrees):
	return degrees * PI/180

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#self.rotate(to_rad(180)) # Rotate Sprite to face in specified starting direction

func get_input(delta):
	# Check if Quiting Application
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	# Handle Rotation / Direction facing
	if Input.is_action_pressed("move_right"):
		mRotVelocity += Globals.MAX_ROTATION_SPEED * delta
		#mRotationDir += 1
		
	if Input.is_action_pressed("move_left"):
		#mRotationDir -= 1;
		mRotVelocity -= Globals.MAX_ROTATION_SPEED * delta

	# Handle Acceleration
	if Input.is_action_pressed("move_forward"):
		if (mVelocity < Globals.MAX_VELOCITY_SPEED):
			var tmp = delta * Globals.MAX_VELOCITY_SPEED
			if(mVelocity + tmp > Globals.MAX_VELOCITY_SPEED):
				mVelocity += mVelocity + tmp - Globals.MAX_VELOCITY_SPEED
			else:
				mVelocity += tmp
		mDirSpeed += mDirectionFacing * mVelocity * delta
	else:
		mVelocity *= Globals.VELOCITY_DAMPENING
		
	if Input.is_action_pressed("move_backwards"):
		if (mVelocity > 0):
			var tmp = delta * Globals.MAX_VELOCITY_SPEED
			if (mVelocity - tmp < 0):
				mVelocity -= 0 - (mVelocity - tmp)	# Get Difference to 0
			else:
				mVelocity -= tmp
				
	

#Adjust Particle Emitters number of particles Emitting based on speed
func handle_particles():
	var particleHolder = self.get_child(4)
	for i in particleHolder.get_child_count():
		particleHolder.get_child(i).emitting = (mVelocity > 0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input(delta)
	
	mDirSpeed *= Globals.SPEED_DAMPENING		# Dampen Direction Moving Velocity
	mRotVelocity *= Globals.ROTATION_DAMPENING	
	mRotationDir += mRotVelocity
	
	if (mRotationDir > 360):
			mRotationDir -= 360
	if (mRotationDir < 0):
			mRotationDir += 360
	if (mVelocity > 0):
		if(mVelocity < Globals.VELOCITY_CUTTOFF):
			mVelocity = 0
			
	handle_particles()
			
	self.rotate(to_rad(mRotVelocity))
	var radAngle = to_rad(mRotationDir)
	mDirectionFacing = Vector2(cos(radAngle), sin(radAngle))
	
	self.set_position(self.get_position() + mDirSpeed)
	
func tractorObject(obj):
	pass
	
func get_camera():
	return self.get_child(3)
	
func get_direction():
	return mDirectionFacing.normalized();

# Check if tractoring is active, and start pulling in junk to Point
func _on_TractorBeam_area_entered(area):
	if(tractoring):
		for i in ObjectsTractoring:
			if(area.get_parent().has_method("tractor_junk")):
				ObjectsTractoring.append(area.get_parent())

func _on_TractorBeam_area_exited(area):
	pass # Replace with function body.
