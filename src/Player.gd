extends KinematicBody2D


var speed = 0.1
var velocity

func _ready():
	velocity = Vector2(0, speed)

func _process(delta):
	move_and_collide(velocity)
