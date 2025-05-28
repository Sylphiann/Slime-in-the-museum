extends CharacterBody2D

@export var speed: float = 150.0
@export var spawn: Vector2 = Vector2(196, 126)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var last_eaten_sprite: Sprite2D = $LastEaten
@onready var eat_timer: Timer = $"../EatTimer"
@onready var mimic_timer: Timer = $"../MimicTimer"

@onready var transform_animation: AnimatedSprite2D = $TransformAnimate

var is_eating: bool = false
var is_mimic: bool = false
var last_direction = Vector2.DOWN


func _ready() -> void:
	transform_animation.hide()
	last_eaten_sprite.hide()
	eat_timer.one_shot = true
	mimic_timer.one_shot = true


func _physics_process(delta: float) -> void:
	if !Stats.can_move:
		return
	
	velocity = Vector2.ZERO
	var input = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	if input.length() > 0:
		velocity = input.normalized() * speed
		last_direction = input.normalized()
		if is_mimic:
			revert_to_slime()
		
	if !is_eating:
		update_animation()
		move_and_slide()
		
	if Input.is_action_just_pressed("eat") and !is_eating and eat_timer.is_stopped():
		if Stats.energy >= Stats.stage_one:
			eat_animation()
			if raycast.is_colliding():
				var collider = raycast.get_collider()
				if collider is Edible:
					eat_timer.start()
					Stats.last_sprite = collider.sprite.duplicate()
					collider.shrink()
					Stats.energy += collider.value
		else:
			print("Not enough energy!")

	if Input.is_action_just_pressed("mimic") and !is_mimic and mimic_timer.is_stopped():
		if Stats.energy >= Stats.stage_two:
			if Stats.last_sprite:
				transform_animation.show()
				transform_animation.play()
				animated_sprite.hide()
				last_eaten_sprite.texture = Stats.last_sprite.texture
				if Stats.last_sprite.hframes > 1:
					last_eaten_sprite.hframes = 3
					last_eaten_sprite.set_frame(Stats.last_sprite.get_frame())
				else:
					last_eaten_sprite.hframes = 1
				is_mimic = true
				mimic_timer.start()
				set_collision_layer_value(2, false)
				last_eaten_sprite.show()
			else:
				print("you haven't eaten anything!")
		else:
			print("Not enough energy!")


func eat_animation():
	is_eating = true
	Stats.can_move = false
	velocity = Vector2.ZERO
	
	var direction: Vector2 = Vector2.ZERO
	direction = last_direction
	
	if abs(last_direction.y) > abs(last_direction.x):
		if last_direction.y > 0:
			animated_sprite.play("down_vacuum")
		else:
			animated_sprite.play("up_vacuum")
	else:
		animated_sprite.play("x_vacuum")
		animated_sprite.flip_h = last_direction.x < 0
	


func update_animation():
	var direction: Vector2 = Vector2.ZERO
	
	if velocity.length() == 0:
		direction = last_direction
		# IDLE animations
		if abs(last_direction.y) > abs(last_direction.x):
			if last_direction.y > 0:
				animated_sprite.play("down_idle")
			else:
				animated_sprite.play("up_idle")
		else:
			animated_sprite.play("x_idle")
			animated_sprite.flip_h = last_direction.x < 0
	else:
		direction = velocity.normalized()
		# WALK animations
		if abs(velocity.y) > abs(velocity.x):
			if velocity.y > 0:
				animated_sprite.play("down_walk")
			else:
				animated_sprite.play("up_walk")
		else:
			animated_sprite.play("x_walk")
			animated_sprite.flip_h = velocity.x < 0
			
	update_raycast_direction(direction)
	
	
func update_raycast_direction(direction: Vector2):
	if direction.length() > 0:
		var ray_length: float = 120.0

		raycast.target_position = direction.normalized() * ray_length


func revert_to_slime():
	if is_mimic:
		set_collision_layer_value(2, true)
		last_eaten_sprite.hide()
		animated_sprite.show()
		is_mimic = false

func respawn():
	Stats.can_move = false
	Stats.hp -= 1
	if Stats.hp <= 0:
		var transition = get_node("/root/Transition")
		transition.play_transition(
			func(): get_tree().change_scene_to_file(str("res://scene/Fail.tscn"))
		)
	else:
		animated_sprite.play("stunned")
		var transition = get_node("/root/Transition")
		transition.play_transition(
			func(): set_position(spawn)
		)
	

func _on_hover_area_entered(area: Area2D) -> void:
	if area is Edible:
		Stats.last_sprite = area.sprite.duplicate()
		Stats.energy += area.value
		area.shrink()


func _on_animated_sprite_2d_animation_finished() -> void:
	is_eating = false
	Stats.can_move = true
	update_animation()


func _on_transform_animate_animation_finished() -> void:
	transform_animation.hide()
