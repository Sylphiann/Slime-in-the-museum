class_name Various extends Edible

@export var rotable: bool = true

var rng = RandomNumberGenerator.new()
func _ready() -> void:
	sprite.set_frame(rng.randi_range(0, 2))
	
	if rotable:
		var rotate: float = rng.randf_range(-90.0, 90.0)
		set_rotation(rotate)
