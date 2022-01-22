extends Node
class_name BouncePad

var is_right = false


func get_class():
	return "BouncePad"


func bounce():
	$BounceSound.play()

func _ready():
	var _i = Signals.connect("slow_motion_start", self, "low_pitch_bounce")
	_i = Signals.connect("slow_motion_end", self, "high_pitch_bounce")

func low_pitch_bounce():
	$BounceSound.pitch_scale = 0.4


func high_pitch_bounce():
	$BounceSound.pitch_scale = 1
