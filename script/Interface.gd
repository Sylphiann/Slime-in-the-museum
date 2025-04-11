extends Control

@onready var progress: TextureProgressBar = $ProgressBar
@onready var count: Label = $Energy/Energy_count
@onready var up_one: Label = $One
@onready var up_two: Label = $Two
@onready var up_three: Label = $Three
@onready var cores: Label = $Lives/Cores
@onready var timer: Timer = $Time/Timer
@onready var timer_label: Label = $Time/Counter

@onready var Qtimer: Timer = $"../../MimicTimer"
@onready var Etimer: Timer = $"../../EatTimer"
@onready var Qcooldown: TextureProgressBar = $ColorRect2/Mimic/TextureProgressBar
@onready var Ecooldown: TextureProgressBar = $ColorRect2/Eat/TextureProgressBar


@export var stage_one: int
@export var stage_two: int
@export var finish: int

func _ready() -> void:
	progress.max_value = finish
	up_one.text = str(stage_one)
	up_two.text = str(stage_two)
	up_three.text = str(finish)
	timer.start()


func _process(delta: float) -> void:
	if timer.is_stopped():
		var transition = get_node("/root/Transition")
		transition.play_transition(
			func(): get_tree().change_scene_to_file(str("res://scene/Fail.tscn"))
		)
	
	progress.value = Stats.energy + 1
	count.text = str(Stats.energy)
	cores.text = str(Stats.hp)
	timer_label.text = "%02d:%02d" % countdown()

	Qcooldown.value = Qtimer.time_left
	Ecooldown.value = Etimer.time_left

func countdown():
	var time_left = timer.time_left
	var minute = float(time_left/60)
	var second = int(time_left) % 60
	return [minute, second]
