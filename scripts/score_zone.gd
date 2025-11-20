extends Area3D
class_name ScoreZone
## Detects when ball passes player and emits score signal.

signal ball_entered_zone(player_number: int)

@export var player_number: int = 1

func _ready() -> void:
	monitoring = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is Ball:
		ball_entered_zone.emit(player_number)
