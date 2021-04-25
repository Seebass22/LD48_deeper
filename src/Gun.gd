extends Sprite

const Bullet = preload("res://Bullet.tscn")

func _ready():
	Signals.connect("slow_motion_start", self, "low_pitch_pew")
	Signals.connect("slow_motion_end", self, "high_pitch_pew")


func _process(delta):
	look_at(get_global_mouse_position())


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			shoot()


func shoot():
	var bullet = Bullet.instance()
	bullet.position = position + Vector2(5, 0).rotated(rotation)
	bullet.rotation = rotation
	get_parent().add_child(bullet)
	$ShootSound.play()


func low_pitch_pew():
	$ShootSound.pitch_scale = 0.4


func high_pitch_pew():
	$ShootSound.pitch_scale = 1
