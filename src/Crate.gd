extends StaticBody2D

var hit = false

func _ready():
	Signals.connect("slow_motion_start", self, "low_pitch_boom")
	Signals.connect("slow_motion_end", self, "high_pitch_boom")


func explode():
	if not hit:
		hit = true
		Signals.emit_signal("crate_destroyed")
		$CollisionShape2D.set_deferred('disabled', true)
		$AnimatedSprite.frame = 1
		$AnimatedSprite.play()
		$ExplosionSound.play()


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.hide()


func _on_ExplosionSound_finished():
	queue_free()


func low_pitch_boom():
	$ExplosionSound.pitch_scale = 0.4


func high_pitch_boom():
	$ExplosionSound.pitch_scale = 1
