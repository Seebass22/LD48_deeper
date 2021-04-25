extends StaticBody2D

var hit = false


func explode():
	if not hit:
		hit = true
		Signals.emit_signal("target_destroyed")
		$CollisionShape2D.set_deferred('disabled', true)
		$AnimatedSprite.frame = 1
		$AnimatedSprite.play()


func _on_AnimatedSprite_animation_finished():
	queue_free()


func _on_DespawnTimer_timeout():
	queue_free()
