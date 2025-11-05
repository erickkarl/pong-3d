extends Node

class_name GameManager

@export var win_score = 5

var player1_score = 0
var player2_score = 0

var ball: Ball

signal score_changed(player1_score: int, player2_score: int)
signal game_over(winner: int)

func _ready() -> void:
	# Find the ball in the scene
	ball = get_node_or_null("../Ball")
	print("GameManager: Ball reference: ", ball)

	# Connect to score zones
	var score_zones = get_tree().get_nodes_in_group("score_zones")
	print("GameManager: Found ", score_zones.size(), " score zones")
	for zone in score_zones:
		if zone.has_signal("ball_entered_zone"):
			zone.ball_entered_zone.connect(_on_ball_scored)
			print("GameManager: Connected to score zone: ", zone.name)

func _on_ball_scored(player_number: int) -> void:
	print("GameManager: _on_ball_scored called! Player: ", player_number)

	# Increment the score for the player who scored
	if player_number == 1:
		player1_score += 1
	elif player_number == 2:
		player2_score += 1

	print("GameManager: New scores - P1: ", player1_score, " P2: ", player2_score)

	# Emit score changed signal
	score_changed.emit(player1_score, player2_score)

	# Check for win condition
	if player1_score >= win_score:
		game_over.emit(1)
		return
	elif player2_score >= win_score:
		game_over.emit(2)
		return

	# Reset the ball
	if ball:
		ball.reset_ball()

func reset_game() -> void:
	player1_score = 0
	player2_score = 0
	score_changed.emit(player1_score, player2_score)

	if ball:
		ball.reset_ball()
