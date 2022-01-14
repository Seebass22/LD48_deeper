extends Node2D

export (NodePath) var _score_path
onready var score_text: Label = get_node(_score_path)

export (NodePath) var _combo_path
onready var combo_ui: HBoxContainer = get_node(_combo_path)

const Crate = preload("res://Crate.tscn")
const Target = preload("res://Target.tscn")
const SlowdownArea = preload("res://SlowdownArea.tscn")
const Obstacle = preload("res://Obstacle.tscn")

var wall_width = 3
var tunnel_width = 9
var segment_size = 16

var current_x_offset = 0
var current_y = 0
var current_direction = 0
var tile_names = {
	"left": ["left1", "left2", "left3"],
	"right": ["right1", "right2", "right3", "right4"],
	"mid": ["mid1", "mid2", "mid3", "mid4", "mid5"],
	"small_corner": ["small_corner1", "small_corner2", "small_corner3", "small_corner4"]
}
var tile_ids = {}
# 1 = right, -1 = left
var segment_direction = -1
var is_new_direction = false

func _ready():
	get_tile_ids()
	randomize()
	var _i = $Player.connect("should_generate_segment", self, "add_segment")
	_i = $Player.connect("should_generate_segment", self, "increase_score_distance")
	_i = Signals.connect("crate_destroyed", self, "increase_score_crate")
	_i = Signals.connect("target_destroyed", self, "increase_score_target")
	_i = Signals.connect("target_destroyed", self, "increment_combo")
	_i = Signals.connect("reset_combo", self, "reset_combo")
	_i = Signals.connect("game_over", self, "game_over")
	add_segment()
	add_segment()
	Global.score = 0
	update_score_ui()
	reset_combo()
	print(tile_names)
	print(tile_ids)

func get_tile_ids():
	for category in tile_names.keys():
		tile_ids[category] = []
		for name in tile_names[category]:
			tile_ids[category].append($Walls.tile_set.find_tile_by_name(name))
	

func _set_cell(x, y, tile_id):
	$Walls.set_cell(x, y, tile_id)
	$Walls.set_cell(x + wall_width + tunnel_width, y, tile_id)
	
func generate_direction_change_segment(x_pos, y_pos):
	var top_tiles
	var bot_tiles
	var offset
	if segment_direction == 1:
		top_tiles = ["corner_bot_left", "mid2", "right_bot_side", "small_corner3"]
		bot_tiles = ["small_corner1", "curve1", "curve2", "corner_top_right"]
		offset = 1
	else:
		top_tiles = ["small_corner2", "curve4", "curve3", "left_bot_side"]
		bot_tiles = ["corner_top_left", "mid1", "right_top_side", "small_corner4"]
		offset = 0

	var y = y_pos
	for tile_row in [top_tiles, bot_tiles]:
		var x = x_pos - offset
		for wall_type in tile_row:
			var tile_id = $Walls.tile_set.find_tile_by_name(wall_type)
			_set_cell(x, y, tile_id)
			x +=1
		y += 1
	
func generate_segment(x_pos, y_pos):
	var segment_height = segment_size
	var new_segment_y_offset = 0
	if is_new_direction:
		is_new_direction = false
		generate_direction_change_segment(x_pos, y_pos)
		segment_height -= 2
		new_segment_y_offset = 2
		
	for y in range(segment_height):
		y += y_pos + new_segment_y_offset

		var x = x_pos
		for wall_type in ["left", "mid", "right"]:
			var tiles = tile_ids[wall_type]
			var tile_id
			if randi() % 4 == 0:
				tile_id = tiles[randi() % tiles.size()]
			else:
				tile_id = tiles[0]
			$Walls.set_cell(x, y, tile_id)
			$Walls.set_cell(x + wall_width + tunnel_width, y, tile_id)
			x +=1

	var start_pos = Vector2(x_pos, y_pos)
	var end_pos = Vector2(x_pos + wall_width*2 + tunnel_width, y_pos + segment_size)
	$Walls.update_bitmask_region(start_pos, end_pos)

	current_y += segment_size


func add_segment():
	var change_direction_chance = 45

	var random = randi() % 100
	if random < change_direction_chance:
		is_new_direction = 1
		segment_direction *= -1
		current_x_offset += segment_direction

		if randi() % 3 == 0:
			add_crate_segment()
		else:
			add_target_segment()

	else:
		if current_y > 2:
			spawn_obstacles()

	generate_segment(current_x_offset, current_y)


func spawn_obstacles():
		var spawn_y = current_y + 4 + randi() % 4
		for _i in range((randi() % 3 ) + 1):
			spawn_y += 1
			spawn_obstacle(spawn_y + 1 + randi() % 5)


func add_crate_segment():
	if current_y < 3:
		return

	var slowdown_area = SlowdownArea.instance()
	var start_x = current_x_offset + wall_width
	slowdown_area.position = Vector2(start_x * 64, current_y * 64)
	add_child(slowdown_area)

	var crate_spawn_y_offset = 4
	for y in range(4):
		y += current_y
		y += crate_spawn_y_offset
		for x in range(tunnel_width):
			var crate = Crate.instance()
			x += current_x_offset + wall_width
			crate.position = Vector2(x * 64, y * 64)
			add_child(crate)


func add_target_segment():
	if current_y < 3:
		return

	var slowdown_area = SlowdownArea.instance()
	var start_x = current_x_offset + wall_width
	slowdown_area.position = Vector2(start_x * 64, current_y * 64)
	add_child(slowdown_area)

	var pattern = randi() % 3

	var target_spawn_y_offset = 4
	for y in range(5):
		y += current_y
		y += target_spawn_y_offset
		for x in range(tunnel_width):

			if pattern == 0:
				# checkerboard pattern
				if (x+y) % 2 == 0:
					continue
			elif pattern == 1:
				# diagonal pattern
				if (x+y) % 4 != 3:
					continue
			elif pattern == 2:
				# vertical lines pattern
				if (x) % 2 == 0:
					continue

			var target = Target.instance()
			x += current_x_offset + wall_width
			target.position = Vector2(x * 64, y * 64)
			add_child(target)


func increase_score_distance():
	Global.score += 20
	update_score_ui()


func increase_score_crate():
	Global.score += 2
	update_score_ui()


func increase_score_target():
	Global.score += 5 * (1 + Global.combo)
	update_score_ui()


func update_score_ui():
	score_text.set_text("%d" % [Global.score])


func game_over():
	get_tree().change_scene("res://GameOver.tscn")


func increment_combo():
	if Global.combo < Global.max_combo:
		Global.combo += 1
		combo_ui.visible = true
	update_combo_ui()
	combo_ui.bounce()


func update_combo_ui():
	combo_ui.get_node("combo").set_text("%d" % [Global.combo])


func reset_combo():
	Global.combo = 0
	combo_ui.visible = false
	update_combo_ui()


func spawn_obstacle(y):
	var start_x = (current_x_offset + wall_width) * 64 + 32
	var obstacle = Obstacle.instance()
	obstacle.position.x = (randi() % 400) + 32
	obstacle.starting_position_x = start_x
	obstacle.position.y = y * 64
	add_child(obstacle)
