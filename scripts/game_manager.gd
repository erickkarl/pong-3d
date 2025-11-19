extends Node
## Manages game state, scoring, and win conditions.
##
## Tracks player health, handles scoring events, and determines
## when a player wins the game.

class_name GameManager

# ============================================================================
# EXPORTS
# ============================================================================

@export var health_damage: int = GameConstants.HEALTH_DAMAGE_PER_SCORE

# ============================================================================
# STATE
# ============================================================================

var player1_health: int = GameConstants.INITIAL_HEALTH
var player2_health: int = GameConstants.INITIAL_HEALTH

var ball: Ball

# ============================================================================
# SIGNALS
# ============================================================================

signal health_changed(player1_health: int, player2_health: int)
signal game_over(winner: int)

func _ready() -> void:
	# Find the ball in the scene
	ball = get_node_or_null("../Ball")

	# Connect to score zones
	var score_zones: Array[Node] = get_tree().get_nodes_in_group("score_zones")

	for zone: Node in score_zones:
		if zone.has_signal("ball_entered_zone"):
			zone.ball_entered_zone.connect(_on_ball_scored)

func _on_ball_scored(player_number: int) -> void:
	# When a player scores, reduce the opponent's health
	if player_number == 1:
		player2_health -= health_damage
	elif player_number == 2:
		player1_health -= health_damage
		
	# Ensure health doesn't go below minimum
	player1_health = max(GameConstants.MIN_HEALTH, player1_health)
	player2_health = max(GameConstants.MIN_HEALTH, player2_health)
		
	# Emit health changed signal
	health_changed.emit(player1_health, player2_health)

	# Check for win condition (health reaches 0 or below)
	if player1_health <= 0:
		game_over.emit(2)  # Player 2 wins
		return
	elif player2_health <= 0:
		game_over.emit(1)  # Player 1 wins
		return

	# Reset the ball
	if ball:
		ball.reset_ball()

func reset_game() -> void:
	player1_health = GameConstants.INITIAL_HEALTH
	player2_health = GameConstants.INITIAL_HEALTH
	health_changed.emit(player1_health, player2_health)

	if ball:
		ball.reset_ball()
