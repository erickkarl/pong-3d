extends Area3D
## Score detection zone for tracking when the ball passes a player.
##
## When the ball enters this zone, it signals that the opposing player has scored.

class_name ScoreZone

# ============================================================================
# EXPORTS
# ============================================================================

@export var player_number: int = 1  # Which player scores when ball enters this zone

# ============================================================================
# SIGNALS
# ============================================================================

signal ball_entered_zone(player_number: int)

func _ready() -> void:
	# Enable monitoring to detect bodies entering this area
	monitoring = true

	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	# Check if it's the ball
	if body is Ball:
		ball_entered_zone.emit(player_number)
