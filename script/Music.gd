extends AudioStreamPlayer2D

var stage_music = preload("res://asset/music/stage.mp3")
var menu_music = preload("res://asset/music/menu.mp3")

func _ready():
	stage_music.loop = true
	menu_music.loop = true

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()
	
func start_stage_music():
	_play_music(stage_music)
	
func start_menu_music():
	_play_music(menu_music)
