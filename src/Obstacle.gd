extends KinematicBody2D

var speed = 500

var direction = 1
var starting_position_x = 0


func _process(delta):
	position.x += direction * delta * speed
	if position.x >= starting_position_x + 448: 
		direction = -1
	if position.x <= starting_position_x:
		direction = 1
