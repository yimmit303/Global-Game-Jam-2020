extends Node

static func shake_camera(camera : Node2D, intensity):
	
	camera.offset = Vector2(0,0)
	
	var decay = 0.8
	
	var effect_scale = 1
	var shake_dist = 10 * intensity
	randomize()
	var move_vector = Vector2(randf() * 2 - 1, randf() * 2 - 1)
	var direction = -1 * move_vector
	
	var tween = Tween.new()
	camera.add_child(tween)
	
	tween.interpolate_property(camera, "offset", 
	camera.offset, camera.offset + (move_vector * shake_dist * effect_scale)
	, 0.1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	
	var last_moved = shake_dist
	
	for i in range(10):
		tween.interpolate_property(camera, "offset", 
		camera.offset, camera.offset + (direction * shake_dist * effect_scale) + (direction * last_moved)
		, 0.05, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		tween.start()
		last_moved = shake_dist * effect_scale
		direction *= -1
		effect_scale *= decay
		yield(tween, "tween_completed")
	
	camera.offset = Vector2(0,0)
	tween.queue_free()
