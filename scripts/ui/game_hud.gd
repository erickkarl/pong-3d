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

	if game_manager:
		# Connect to signals
		game_manager.health_changed.connect(_on_health_changed)
		game_manager.game_over.connect(_on_game_over)

	# Hide game over panel initially
	if game_over_panel:
		game_over_panel.visible = false

	# Initialize health
	update_health(100, 100)

func _on_health_changed(player1_health: int, player2_health: int) -> void:
	update_health(player1_health, player2_health)

func update_health(player1_health: int, player2_health: int) -> void:
	if player1_score_label:
		player1_score_label.text = str(player1_health)
	if player2_score_label:
		player2_score_label.text = str(player2_health)

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
