extends "res://scripts/player/player_controller.gd"

func _ready() -> void:
	move_up_key = KEY_UP
	move_down_key = KEY_DOWN
	speed = GameConstants.PLAYER_MOVEMENT_SPEED
	super._ready()
