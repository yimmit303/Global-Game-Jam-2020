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
		self.get_parent().get_audio_manager().play_looping_sound("Engine")
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
		self.get_parent().get_audio_manager().stop_looping_sound("Engine")
		if (mVelocity > 0):
			var tmp = delta * Globals.MAX_VELOCITY_SPEED
			if (mVelocity - tmp < 0):
				mVelocity -= 0 - (mVelocity - tmp)	# Get Difference to 0
			else:
				mVelocity -= tmp
				
	if Input.is_action_pressed("gravity_beam"):
		$ShipComponents/TractorParticles.emitting = true
		tractoring = true
	else:
		$ShipComponents/TractorParticles.emitting = false
		tractoring = false
		if(ObjectsHeld.size() > 0):
			self.get_parent().get_audio_manager().play_sound("TractorShoot")
			for i in range(ObjectsHeld.size()):
				var obj = ObjectsHeld[i]
				ObjectsHeld.remove(i)
				$ShipComponents/TractorPoint.remove_child(obj)
				self.get_parent().add_child(obj)
				obj.set_position($ShipComponents/TractorPoint.get_global_position())
				obj.fire_trash(mDirectionFacing)

#Adjust Particle Emitters number of particles Emitting based on speed
func handle_particles():
	var particleHolder = $ShipComponents/EngineParticles
	for i in particleHolder.get_child_count():
		particleHolder.get_child(i).emitting = (mVelocity > 0)

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
			self.get_parent().get_audio_manager().stop_looping_sound("Engine")
			mVelocity = 0
			
	handle_particles()
			
	self.rotate(Globals.to_rad(mRotVelocity))
	$ShipComponents/Background.rotate(Globals.to_rad(-mRotVelocity))
	var radAngle = Globals.to_rad(mRotationDir)
	mDirectionFacing = Vector2(cos(radAngle), sin(radAngle))
	self.set_position(self.get_position() + mDirSpeed)
	
	# Tractor Objects to Player
	if(tractoring):
		for i in range(ObjectsTractoring.size()):
			tractorObject(ObjectsTractoring[i], i, delta)
	
func tractorObject(obj, index, delta):
	var pointToReach = $ShipComponents/TractorPoint.get_global_position()
	if(ObjectsHeld.size() == 0): #and obj.is_inrange(pointToReach)):
		ObjectsTractoring.remove(index)
		ObjectsHeld.append(obj)
		obj.set_playerOwned()
		obj.get_parent().remove_child(obj)
		$ShipComponents/TractorPoint.add_child(obj)
		obj.set_position($ShipComponents/TractorPoint.get_position())
	else:
		obj.tractor_junk(pointToReach, delta)
	
func get_camera():
	return $ShipComponents/Camera2D
	
func get_direction():
	return mDirectionFacing.normalized();

# Check if tractoring is active, and start pulling in junk to Point
func _on_TractorBeam_area_entered(area):
	if(area.get_parent().has_method("tractor_junk")):
		if (ObjectsTractoring.size() > 0):
			if (ObjectsTractoring.find(area.get_parent()) == -1):
				ObjectsTractoring.append(area.get_parent())
		else:
			ObjectsTractoring.append(area.get_parent())

func _on_TractorBeam_area_exited(area):
	if(area.get_parent().has_method("tractor_junk")):
		var obj_Index = ObjectsTractoring.find(area.get_parent())
		if (obj_Index != -1):
			ObjectsTractoring.remove(obj_Index)
