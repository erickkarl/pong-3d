extends "res://scripts/player/player_controller.gd"

func _ready() -> void:
	move_up_key = KEY_W
	move_down_key = KEY_S
	speed = GameConstants.PLAYER_MOVEMENT_SPEED
	super._ready()
