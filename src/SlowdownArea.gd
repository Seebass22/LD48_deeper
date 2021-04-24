extends Area2D


func _on_SlowdownArea_body_entered(body):
	Engine.time_scale = 0.2
	print("slow_motion")


func _on_SlowdownArea_body_exited(body):
	Engine.time_scale = 1
	print("normal_speed")
