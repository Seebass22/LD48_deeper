extends Node2D

var wall_width = 2
var tunnel_width = 8

func _ready():
	for y in range(16):
		for x in range(wall_width):
			$Walls.set_cell(x, y, 0)

	for y in range(16):
		for x in range(wall_width):
			$Walls.set_cell(x + wall_width + tunnel_width, y, 0)

	$Walls.update_bitmask_region(Vector2(0.0, 0.0), Vector2(16, 16))
