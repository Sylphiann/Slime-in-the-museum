extends Node

# Player stats
var hp: int = 3
var energy: int = 0
var can_move: bool = true
var last_sprite: Sprite2D

# Level stats
var stage_one: int = 5
var stage_two: int = 25
var finish: int = 50
var current_level: String = "res://scene/Level1.tscn"
var level_two_unlocked: bool = false
