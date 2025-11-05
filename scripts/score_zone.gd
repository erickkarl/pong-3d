extends Area3D

class_name ScoreZone

@export var player_number = 1  # Which player scores when ball enters this zone

signal ball_entered_zone(player_number)

func _ready() -> void:
	# Enable monitoring to detect bodies entering this area
	monitoring = true

	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	print("ScoreZone: Body entered: ", body.name, " Type: ", body.get_class())

	# Check if it's the ball
	if body is Ball:
		print("ScoreZone: Ball detected! Emitting signal for player ", player_number)
		ball_entered_zone.emit(player_number)
	else:
		print("ScoreZone: Not a ball, it's a: ", body.get_class())
