extends Node

export (NodePath) var _score_path
onready var score_text = get_node(_score_path)

func _ready():
	score_text.set_text("%d" % [Global.score])
	$PlayAgain.visible = false
	$MainMenu.visible = false
	for y in range(2):
		for x in range(4):
			yield(get_tree().create_timer(0.05), "timeout")
			$TileMap.set_cell(x+5, y+2, 0)
			$TileMap.update_bitmask_region(Vector2(0,0), Vector2(16,16))

	$PlayAgain.visible = true

	for y in range(2):
		for x in range(4):
			yield(get_tree().create_timer(0.05), "timeout")
			$TileMap.set_cell(x+6, y+5, 0)
			$TileMap.update_bitmask_region(Vector2(0,0), Vector2(16,16))

	$MainMenu.visible = true


func _on_PlayAgain_button_up():
	get_tree().change_scene("res://Game.tscn")
