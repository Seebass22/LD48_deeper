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
var tunnel_width = 8
var segment_size = 16

var current_x_offset = 0
var current_y = 0
var current_direction = 0


func _ready():
	$Player.connect("should_generate_segment", self, "add_segment")
	$Player.connect("should_generate_segment", self, "increase_score_distance")
	Signals.connect("crate_destroyed", self, "increase_score_crate")
	Signals.connect("target_destroyed", self, "increase_score_target")
	Signals.connect("target_destroyed", self, "increment_combo")
	Signals.connect("reset_combo", self, "reset_combo")
	Signals.connect("game_over", self, "game_over")
	add_segment()
	add_segment()
	Global.score = 0
	update_score_ui()
	reset_combo()


func generate_segment(x_pos, y_pos):
	for y in range(segment_size):
		y += y_pos
		for x in range(wall_width):
			x += x_pos
			$Walls.set_cell(x, y, 0)
			$Walls.set_cell(x + wall_width + tunnel_width, y, 0)

	var start_pos = Vector2(x_pos, y_pos)
	var end_pos = Vector2(x_pos + wall_width*2 + tunnel_width, y_pos + segment_size)
	$Walls.update_bitmask_region(start_pos, end_pos)

	current_y += segment_size


func add_segment():
	var change_direction_chance = 40

	randomize()
	var random = randi() % 100
	if random < change_direction_chance:
		current_x_offset += pow(-1, randi() % 2 + 1)
		if randi() % 2 == 0:
			add_crate_segment()
		else:
			add_target_segment()

	else:
		if current_y > 2:
			spawn_obstacles()

	generate_segment(current_x_offset, current_y)


func spawn_obstacles():
		var spawn_y = current_y + 4 + randi() % 4
		for i in range((randi() % 3 ) + 1):
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

	randomize()
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
	randomize()
	var start_x = (current_x_offset + wall_width) * 64 + 32
	var obstacle = Obstacle.instance()
	obstacle.position.x = (randi() % 400) + 32
	obstacle.starting_position_x = start_x
	obstacle.position.y = y * 64
	add_child(obstacle)
