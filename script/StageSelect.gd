extends CanvasLayer


@onready var level_two: LinkButton = $ColorRect/Level2

func _ready() -> void:
	Music.start_menu_music()
	if !Stats.level_two_unlocked:
		level_two.disabled = true
	else:
		level_two.disabled = false


func _on_level_1_pressed() -> void:
	var transition = get_node("/root/Transition")
	transition.play_transition(
		func(): get_tree().change_scene_to_file(str("res://scene/Level1.tscn"))
	)


func _on_level_2_pressed() -> void:
	var transition = get_node("/root/Transition")
	transition.play_transition(
		func(): get_tree().change_scene_to_file(str("res://scene/Level2.tscn"))
	)


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(str("res://scene/MainMenu.tscn"))
