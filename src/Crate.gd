extends StaticBody2D

func explode():
	$AnimatedSprite.frame = 1
	$AnimatedSprite.play()


func _on_AnimatedSprite_animation_finished():
	queue_free()

