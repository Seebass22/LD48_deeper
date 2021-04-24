extends Sprite

const Bullet = preload("res://Bullet.tscn")

func _ready():
	pass # Replace with function body.


func _process(delta):
	look_at(get_global_mouse_position())


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			shoot()

func shoot():
	var bullet = Bullet.instance()
	bullet.position = position + Vector2(5, 0).rotated(rotation)
	# bullet.velocity = velocity
	bullet.rotation = rotation
	get_parent().add_child(bullet)
