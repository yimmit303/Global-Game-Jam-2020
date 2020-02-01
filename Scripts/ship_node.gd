extends Area2D

var mNodeHealth = 100
var mSheild = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Collision handeling for Node, gets damage from other Object if its hostile
# If other object has get_val / is a scrap item, if held the item will heal or add to shield
func _on_Node_area_entered(area):
	if(area.has_method("get_damage")):		# Enemy bullet
		mNodeHealth -= area.get_damage()
	elif(area.has_method("get_val")):		# Attach Junk
		var healAmt = area.get_val()
		
		# Handle Incrementing Health and Shield
		if(mNodeHealth + healAmt > Globals.MAX_HEALTH):
			if(mSheild < Globals.MAX_SHEILD):
				var tmp = (mNodeHealth + healAmt) - 100
				mNodeHealth += healAmt - tmp
				mSheild += mSheild + tmp - Globals.MAX_HEALTH
		else:
			mNodeHealth += healAmt
