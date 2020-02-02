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
	var parObj = area.get_parent()
	if(parObj.has_method("get_damage")):		# Enemy bullet
		var dmgDealt = parObj.get_damage()
		if(mNodeHealth - dmgDealt < 0):
			mNodeHealth = 0
		else:
			mNodeHealth -= dmgDealt
		load("res://Scripts/CameraShake.gd").shake_camera(get_node("../../Camera2D"), 1.0)
		adjust_health_filter()

	elif(parObj.has_method("get_value")):		# Repair using Junk
		var healAmt = parObj.get_value()
		if(healAmt > 0 and mNodeHealth < Globals.MAX_HEALTH and parObj.is_dragged()):
			# Handle Incrementing Health and Shield
			if(mNodeHealth + healAmt > Globals.MAX_HEALTH):
				var healDiff = (mNodeHealth + healAmt) - Globals.MAX_HEALTH
				mNodeHealth += healAmt - healDiff
				parObj.queue_free()
			else:
				print("Heal amount: ",healAmt)
				print("CurrentHealth: ",mNodeHealth)
				mNodeHealth += healAmt
				parObj.queue_free()
			adjust_health_filter()
		
