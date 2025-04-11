extends CanvasLayer

func _ready() -> void:
	Music.start_menu_music()


func _on_start_pressed() -> void:
	var transition = get_node("/root/Transition")
	transition.play_transition(
		func(): get_tree().change_scene_to_file(str("res://scene/Level1.tscn"))
	)


func _on_stage_select_pressed() -> void:
	get_tree().change_scene_to_file(str("res://scene/StageSelect.tscn"))


func _on_quit_pressed() -> void:
	get_tree().quit()
