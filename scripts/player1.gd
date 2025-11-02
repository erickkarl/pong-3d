extends "res://player.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_up_key = KEY_W
	move_down_key = KEY_S
	
	speed = 1
