extends CanvasLayer

class_name GameHUD

@onready var player1_score_label = $ScoreContainer/Player1Score
@onready var player2_score_label = $ScoreContainer/Player2Score
@onready var game_over_panel = $GameOverPanel
@onready var winner_label = $GameOverPanel/VBoxContainer/WinnerLabel

var game_manager: GameManager

func _ready() -> void:
	# Find the game manager (HUD is sibling to GameManager in scene tree)
	game_manager = get_node_or_null("../GameManager")

	print("HUD: GameManager reference: ", game_manager)

	if game_manager:
		# Connect to signals
		game_manager.score_changed.connect(_on_score_changed)
		game_manager.game_over.connect(_on_game_over)
		print("HUD: Successfully connected to GameManager signals")
	else:
		print("HUD: ERROR - Could not find GameManager!")

	# Hide game over panel initially
	if game_over_panel:
		game_over_panel.visible = false

	# Initialize scores
	update_scores(0, 0)

func _on_score_changed(player1_score: int, player2_score: int) -> void:
	print("HUD: _on_score_changed called! P1: ", player1_score, " P2: ", player2_score)
	update_scores(player1_score, player2_score)

func update_scores(player1_score: int, player2_score: int) -> void:
	print("HUD: Updating score labels. P1 label: ", player1_score_label, " P2 label: ", player2_score_label)
	if player1_score_label:
		player1_score_label.text = str(player1_score)
		print("HUD: Set P1 label to: ", player1_score_label.text)
	if player2_score_label:
		player2_score_label.text = str(player2_score)
		print("HUD: Set P2 label to: ", player2_score_label.text)

func _on_game_over(winner: int) -> void:
	if game_over_panel:
		game_over_panel.visible = true

	if winner_label:
		winner_label.text = "Player " + str(winner) + " Wins!"

func _on_restart_pressed() -> void:
	if game_manager:
		game_manager.reset_game()

	if game_over_panel:
		game_over_panel.visible = false

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_main_menu_button_pressed() -> void:
	_on_main_menu_pressed()


func _on_restart_button_pressed() -> void:
	_on_restart_pressed()
