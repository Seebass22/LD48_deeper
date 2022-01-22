extends KinematicBody2D

var max_x_speed = 0.15
var y_speed = 0.13
var velocity
var acceleration = 0.6

var next_segment_generation_y = 1024

signal should_generate_segment


func _ready():
	velocity = Vector2(0, y_speed)


func _process(delta):
	handle_input(delta)

	var collision = move_and_collide(velocity * 5000 * delta)
	if collision:
		var obj = collision.collider
		if obj.get_class() == "BouncePad":
			Signals.emit_signal("bounce")
			var direction = 1
			if obj.is_right:
				direction = -1
			velocity. x += 0.3 * direction
			obj.bounce()

		elif obj.get_class() == "Obstacle":
			Signals.emit_signal("game_over")
		# else:

	if position.y >= next_segment_generation_y:
		next_segment_generation_y += 1024
		emit_signal("should_generate_segment")


func handle_input(delta):
	if Input.is_action_pressed("left"):
		if velocity.x > -max_x_speed:
			velocity.x -= acceleration * delta
	elif Input.is_action_pressed("right"):
		if velocity.x < max_x_speed:
			velocity.x += acceleration * delta


func _physics_process(_delta):
	velocity.x *= 0.95
