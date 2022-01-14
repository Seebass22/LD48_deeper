extends KinematicBody2D

var speed = 450

var direction = 1
var starting_position_x = 0
var tunnel_width = 448
var obstacle_width = 64

func _process(delta):
	position.x += direction * delta * speed
	if position.x >= starting_position_x + (tunnel_width - obstacle_width):
		direction = -1
	if position.x <= starting_position_x:
		direction = 1
