extends Node2D

# Direction Vector and Velocity Vector
var mDirectionFacing = Vector2()
var mDirSpeed = Vector2()

# Velocity of Ship per frame
var mVelocity = 0
var mRotVelocity = 0

# Angle The Ship Sprite is facing in Degrees
var mRotationDir = 270

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
		
	if Input.is_action_pressed("move_backwards"):
		if (mVelocity > 0):
			var tmp = delta * Globals.MAX_VELOCITY_SPEED
			if (mVelocity - tmp < 0):
				mVelocity -= 0 - (mVelocity - tmp)	# Get Difference to 0
			else:
				mVelocity -= tmp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input(delta)
	
	mDirSpeed *= .99	# Dampen Velocity
	mRotVelocity *= .95
	mRotationDir += mRotVelocity
	
	if (mRotationDir > 360):
			mRotationDir -= 360
	if (mRotationDir < 0):
			mRotationDir += 360
			
	self.rotate(to_rad(mRotVelocity))
	var radAngle = to_rad(mRotationDir)
	mDirectionFacing = Vector2(cos(radAngle), sin(radAngle))
	
	self.set_position(self.get_position() + mDirSpeed)
