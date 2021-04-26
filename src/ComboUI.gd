extends HBoxContainer

var time = 0.02
var trans_type = Tween.TRANS_LINEAR

onready var end_position = rect_position


func bounce():

	var start_position = end_position - Vector2(20,20)

	var tween_node = get_node("Tween")

	tween_node.interpolate_property(self, "rect_position", start_position, end_position, time, trans_type, Tween.EASE_OUT)
	tween_node.start()
