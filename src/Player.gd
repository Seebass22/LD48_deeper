extends KinematicBody2D


var max_x_speed = 0.1
var y_speed = 0.1
var velocity

func _ready():
	velocity = Vector2(0, y_speed)


func _process(delta):
	move_and_collide(velocity)
	handle_input(delta)


func handle_input(delta):
	if Input.is_action_pressed("left"):
		if velocity.x > -max_x_speed:
			velocity.x -= 0.5 * delta
	if Input.is_action_pressed("right"):
		if velocity.x < max_x_speed:
			velocity.x += 0.5 * delta
