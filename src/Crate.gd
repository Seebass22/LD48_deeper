extends StaticBody2D

var hit = false

func explode():
	if not hit:
		hit = true
		$AnimatedSprite.frame = 1
		$AnimatedSprite.play()


func _on_AnimatedSprite_animation_finished():
	queue_free()

