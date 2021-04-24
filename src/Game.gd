extends Node2D

var wall_width = 3
var tunnel_width = 8
var segment_size = 16

var current_x_offset = 0
var current_y = 0
var current_direction = 0


func _ready():
	$Player.connect("should_generate_segment", self, "add_segment")
	add_segment()
	add_segment()


func generate_segment(x_pos, y_pos):
	for y in range(segment_size):
		y += y_pos
		for x in range(wall_width):
			x += x_pos
			$Walls.set_cell(x, y, 0)

	for y in range(segment_size):
		y += y_pos
		for x in range(wall_width):
			x += x_pos
			$Walls.set_cell(x + wall_width + tunnel_width, y, 0)

	var start_pos = Vector2(x_pos, y_pos)
	var end_pos = Vector2(x_pos + wall_width*2 + tunnel_width, y_pos + segment_size)
	$Walls.update_bitmask_region(start_pos, end_pos)

	current_y += segment_size


func add_segment():
	var change_direction_chance = 20

	randomize()
	if randi() % 100 < change_direction_chance:
		print('change direction')
		current_x_offset += pow(-1, randi() % 2 + 1)

	generate_segment(current_x_offset, current_y)
