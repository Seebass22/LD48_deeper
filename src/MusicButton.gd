extends TextureButton

func _ready():
	pressed = not Global.music_enabled
	toggle_mute()
	$Music.play()


func _on_MusicButton_toggled(button_pressed):
	Global.music_enabled = not button_pressed
	toggle_mute()


func toggle_mute():
	if Global.music_enabled:
		$Music.volume_db = 0
	else:
		$Music.volume_db = -80
