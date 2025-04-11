extends Node2D

@export var stage_one: int = 5
@export var stage_two: int = 25
@export var finish: int = 50

@onready var pause: CanvasLayer = $Pause
var is_paused: bool = false

func _ready() -> void:
	Music.start_stage_music()
	Stats.can_move = true
	Stats.hp = 3
	Stats.energy = 0
	pause.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause():
	is_paused = !is_paused
	if is_paused:
		pause.show()
	else:
		pause.hide()


func _on_winning_body_entered(body: Node2D) -> void:
	if body.name == "Slime" and Stats.energy >= Stats.finish:
		Stats.level_two_unlocked = true
		var transition = get_node("/root/Transition")
		transition.play_transition(
			func(): get_tree().change_scene_to_file(str("res://scene/Level2.tscn"))
		)
