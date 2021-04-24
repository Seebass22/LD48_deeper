extends KinematicBody2D

var speed = 3000
var velocity = Vector2()

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()
		if collision.collider.has_method('explode'):
			collision.collider.explode()
			queue_free()


func _ready():
	setBulletSpeed()


func setBulletSpeed():
	velocity = Vector2(speed, 0).rotated(rotation)


func _on_Bullet_body_entered(body):
	if body.has_method('explode'):
		body.explode()
