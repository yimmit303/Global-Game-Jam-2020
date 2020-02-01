extends Node

static func shake_camera(camera : Node2D, intensity):
	var initial_position = camera.offset
	
	var decay = 0.8
	
	var effect_scale = 1
	var shake_dist = 40 * intensity
	var move_vector = Vector2(0, 1)#Vector2(randf() * 2 - 1, randf() * 2 - 1)
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
		, 0.1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		tween.start()
		last_moved = shake_dist * effect_scale
		direction *= -1
		effect_scale *= decay
		yield(tween, "tween_completed")
	
	camera.offset = initial_position
	tween.queue_free()
