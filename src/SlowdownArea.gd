extends Area2D


func _on_SlowdownArea_body_entered(body):
	Engine.time_scale = 0.2
	Signals.emit_signal("slow_motion_start")


func _on_SlowdownArea_body_exited(body):
	Engine.time_scale = 1
	Signals.emit_signal("slow_motion_end")
