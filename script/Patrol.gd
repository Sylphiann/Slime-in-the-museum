extends PathFollow2D

@onready var path: Path2D = $".."
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D
@onready var detection: Area2D = $Flashlight
@onready var raycast: RayCast2D = $RayCast2D

@export var speed: float = 110.0
@export var wait_time: float = 3.0

var direction: int = 1
var waiting: bool = false


func _ready():
	animation.play("walk_sideways")
	

func _process(delta: float) -> void:
	if waiting:
		return

	progress += speed * direction * delta
	update_animation()
	
	if progress_ratio >= 1.0:
		direction = -1
		wait()
	elif progress_ratio <= 0.0:
		direction = 1
		wait()
		

func wait():
	waiting = true
	animation.stop()
	await get_tree().create_timer(wait_time).timeout
	animation.play()
	waiting = false
	
	
func update_animation():
	var old_pos = path.curve.sample_baked(progress - direction * 1.0)
	var new_pos = path.curve.sample_baked(progress)
	var movement_vector = new_pos - old_pos
	
	light.rotation = movement_vector.angle()
	detection.rotation = movement_vector.angle()

	if abs(movement_vector.x) > abs(movement_vector.y):
		animation.animation = "walk_sideways"
		animation.flip_h = movement_vector.x < 0
	elif movement_vector.y < 0:
		animation.animation = "walk_up"
		animation.flip_h = false
	else:
		animation.animation = "walk_down"
		animation.flip_h = false

	if !animation.is_playing():
		animation.play()


func _on_flashlight_body_entered(body: Node2D) -> void:
	if body.name == "Slime":
		# this took an hour to debug TwT
		raycast.target_position = body.global_position - raycast.global_position
		raycast.force_raycast_update()
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider == body:
				body.respawn()
	return
