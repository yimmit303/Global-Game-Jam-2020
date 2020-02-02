extends Area2D

var mNodeHealth = 100
var mSheild = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Health_Filter.visible = false
	pass # Replace with function body.
	
func adjust_health_filter():
	$Health_Filter.visible = mNodeHealth < 100.0
	$Health_Filter.modulate[0] = (100.0 - mNodeHealth) / 100.0
	$Health_Filter.modulate[1] = mNodeHealth / 100.0

# Collision handeling for Node, gets damage from other Object if its hostile
# If other object has get_val / is a scrap item, if held the item will heal or add to shield
func _on_Node_area_entered(area):
	if(area.get_parent().has_method("get_damage")):		# Enemy bullet
		var dmgDealt = area.get_parent().get_damage()
		if(mNodeHealth - dmgDealt < 0):
			mNodeHealth = 0
		else:
			mNodeHealth -= dmgDealt
		load("res://Scripts/CameraShake.gd").shake_camera(get_node("../../Camera2D"), 1.0)
		adjust_health_filter()

	elif(area.get_parent().get_parent().has_method("get_value")):		# Repair using Junk
		print("medic!!")
		var healAmt = area.get_value()
		print("Heal amount: ",healAmt)
		print("CurrentHealth: ",mNodeHealth)
		if(healAmt > 0):
			# Handle Incrementing Health and Shield
			if(mNodeHealth + healAmt > Globals.MAX_HEALTH):
				var healDiff = (mNodeHealth + healAmt) - Globals.MAX_HEALTH
				mNodeHealth += healAmt - healDiff
				
				#if(mSheild< Globals.MAX_SHEILD):
				#	mSheild += mSheild + healDiff - Globals.MAX_HEALTH
				area.get_parent().queue_free()
			else:
				mNodeHealth += healAmt
				area.get_parent().queue_free()
		adjust_health_filter()
		
