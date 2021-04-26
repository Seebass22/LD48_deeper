extends Node

var tile_spawn_delay = 0.03

func _ready():
	$Title.visible = false
	$Play.visible = false
	$Quit.visible = false
	$PanelText.visible = false
	$MusicButton.visible = false

	for y in range(6):
		for x in range(3):
			yield(get_tree().create_timer(tile_spawn_delay), "timeout")
			$TileMap.set_cell(x+1, y, 0)
			$TileMap.update_bitmask_region(Vector2(0,0), Vector2(16,16))

	for y in range(3):
		for x in range(3):
			yield(get_tree().create_timer(tile_spawn_delay), "timeout")
			$TileMap.set_cell(x+2, y+6, 0)
			$TileMap.update_bitmask_region(Vector2(0,0), Vector2(16,16))

	# title BG
	for x in range(6, 0, -1):
		for y in range(2):
			yield(get_tree().create_timer(tile_spawn_delay), "timeout")
			$TileMap.set_cell(x+5, y, 0)
			$TileMap.update_bitmask_region(Vector2(0,0), Vector2(16,16))
	$Title.visible = true

	# play button BG
	for x in range(3):
		yield(get_tree().create_timer(tile_spawn_delay), "timeout")
		$TileMap.set_cell(x+5, 3, 0)
		$TileMap.update_bitmask_region(Vector2(0,0), Vector2(16,16))
	$Play.visible = true

	# quit button BG
	if not OS.get_name() == "HTML5":
		for x in range(3):
			yield(get_tree().create_timer(tile_spawn_delay), "timeout")
			$TileMap.set_cell(x+6, 5, 0)
			$TileMap.update_bitmask_region(Vector2(0,0), Vector2(16,16))
		$Quit.visible = true

	# panel BG
	for x in range(5):
		for y in range(6):
			yield(get_tree().create_timer(tile_spawn_delay), "timeout")
			$TileMap.set_cell(x+10, y+3, 1)
			$TileMap.update_bitmask_region(Vector2(0,0), Vector2(16,16))
	$PanelText.visible = true

	$MusicButton.pressed = not Global.music_enabled
	$MusicButton.visible = true


func _on_Play_button_up():
	get_tree().change_scene("res://Game.tscn")


func _on_Quit_button_up():
	get_tree().quit()


func _on_MusicButton_toggled(button_pressed):
	Global.music_enabled = not button_pressed
