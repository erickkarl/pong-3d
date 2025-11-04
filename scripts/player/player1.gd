extends "res://scripts/player/player.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	move_up_key = KEY_W
	move_down_key = KEY_S
	
	speed = 0.5

func _on_ball_body_entered(body: Node) -> void:
	pass # Replace with function body.
