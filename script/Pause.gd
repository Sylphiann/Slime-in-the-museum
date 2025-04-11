extends CanvasLayer


func resume():
	get_tree().paused = false


func pause():
	get_tree().paused = true


func testEsc():
	if Input.is_action_just_pressed("ui_cancel") and !get_tree().paused:
		print("ye")
		pause()
	elif Input.is_action_just_pressed("ui_cancel") and get_tree().paused:
		resume()


func _on_resume_pressed():
	resume()


func _process(delta):
	testEsc()
	if Input.is_action_just_pressed("ui_cancel"):
		_on_resume_pressed()


func _on_retry_pressed() -> void:
	var transition = get_node("/root/Transition")
	transition.play_transition(
		func(): get_tree().change_scene_to_file("res://scene/Level1.tscn")
	)


func _on_main_menu_pressed() -> void:
	var transition = get_node("/root/Transition")
	transition.play_transition(
		func(): get_tree().change_scene_to_file("res://scene/MainMenu.tscn")
	)
