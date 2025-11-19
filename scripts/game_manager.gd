extends Node
class_name GameManager
## Tracks health, handles scoring, and determines win conditions.

signal health_changed(player1_health: int, player2_health: int)
signal game_over(winner: int)

@export var health_damage: int = GameConstants.HEALTH_DAMAGE_PER_SCORE

var player1_health: int = GameConstants.INITIAL_HEALTH
var player2_health: int = GameConstants.INITIAL_HEALTH
var ball: Ball

func _ready() -> void:
	ball = get_node_or_null("../Ball")

	var score_zones: Array[Node] = get_tree().get_nodes_in_group("score_zones")
	for zone: Node in score_zones:
		if zone.has_signal("ball_entered_zone"):
			zone.ball_entered_zone.connect(_on_ball_scored)

func _on_ball_scored(player_number: int) -> void:
	if player_number == 1:
		player2_health -= health_damage
	elif player_number == 2:
		player1_health -= health_damage

	player1_health = max(GameConstants.MIN_HEALTH, player1_health)
	player2_health = max(GameConstants.MIN_HEALTH, player2_health)

	health_changed.emit(player1_health, player2_health)

	if player1_health <= 0:
		game_over.emit(2)
		return
	elif player2_health <= 0:
		game_over.emit(1)
		return

	if ball:
		ball.reset_ball()

func reset_game() -> void:
	player1_health = GameConstants.INITIAL_HEALTH
	player2_health = GameConstants.INITIAL_HEALTH
	health_changed.emit(player1_health, player2_health)

	if ball:
		ball.reset_ball()
