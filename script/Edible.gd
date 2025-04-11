class_name Edible extends Area2D

@onready var player: CharacterBody2D = $"../../Slime"
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

@export var value: int
@export var shrink_speed: float = 8.0
@export var move_speed: float = 5.0

var vanish_threshold := 0.05
var shrinking: bool = false

func _process(delta: float) -> void:
	if shrinking:
		var new_scale = scale.lerp(Vector2.ZERO, delta * shrink_speed)
		scale = new_scale
		
		if player:
			global_position = global_position.lerp(player.global_position, delta * move_speed)
		
		if scale.length()< vanish_threshold:
			queue_free()

func shrink() -> void:
	collision.queue_free()
	shrinking = true
