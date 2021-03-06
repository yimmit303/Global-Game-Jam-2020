extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true

func _on_Play_pressed():
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.interpolate_property($MenuCamera, "zoom", Vector2(1,1), Vector2(0.75,0.75), 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	get_tree().paused = false
	$MenuCamera.current = false
	self.queue_free()

func _on_Quit_pressed():
	get_tree().quit()
