extends KinematicBody2D

var max_x_speed = 0.14
var y_speed = 0.11
var velocity
var acceleration = 1.8

var next_segment_generation_y = 1024
var last_bounce = OS.get_unix_time()

signal should_generate_segment


func _ready():
	velocity = Vector2(0, y_speed)


func _process(delta):
	handle_input(delta)
	velocity.y = y_speed

	var collision = move_and_collide(velocity * 5000 * delta)
	if collision:
		var obj = collision.collider
		if obj.get_class() == "BouncePad":
			var time = OS.get_unix_time()
			if time > last_bounce + 1:
				last_bounce = time
				Signals.emit_signal("bounce")
				var direction = 1
				if obj.is_right:
					direction = -1
				velocity. x += 0.5 * direction
				obj.bounce()

		elif obj.get_class() == "Obstacle":
			Signals.emit_signal("game_over")
			
		elif obj.get_class() == "TileMap":
			velocity.x *= -1

		else:
			var direction = 1
			if obj.scale.x == -1:
				direction = -1
			velocity.x += 10 * delta * direction

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
