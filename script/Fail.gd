extends CanvasLayer

func _ready() -> void:
	Music.start_menu_music()

func _on_main_menu_pressed() -> void:
	var transition = get_node("/root/Transition")
	transition.play_transition(
		func(): get_tree().change_scene_to_file(str("res://scene/MainMenu.tscn"))
	)


func _on_retry_pressed() -> void:
	var transition = get_node("/root/Transition")
	transition.play_transition(
		func(): get_tree().change_scene_to_file(str("res://scene/Level1.tscn"))
	)
