extends CanvasLayer

@onready var animation: AnimationPlayer = $AnimationPlayer
var callback_after_transition: Callable


func play_transition(callback: Callable):
	callback_after_transition = callback
	animation.play("fade_out")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		if callback_after_transition:
			callback_after_transition.call()
		await get_tree().create_timer(0.6).timeout
		Stats.can_move = true
		animation.play("fade_in")
