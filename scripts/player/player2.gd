extends "res://scripts/player/player.gd"

func _ready() -> void:
	super._ready()
	move_up_key = KEY_UP
	move_down_key = KEY_DOWN
	
	speed = 0.5
