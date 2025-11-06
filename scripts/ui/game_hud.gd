extends CanvasLayer

class_name GameHUD

# Health bar references
@onready var player1_health_bar = $HealthBarContainer/Player1Container/HealthBar
@onready var player2_health_bar = $HealthBarContainer/Player2Container/HealthBar

# Game over panel references
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

	# Initialize health bars
	update_health(100, 100)

func _on_health_changed(player1_health: int, player2_health: int) -> void:
	update_health(player1_health, player2_health)

func update_health(player1_health: int, player2_health: int) -> void:
	# Update Player 1 health bar
	if player1_health_bar:
		player1_health_bar.value = player1_health
		# Change color based on health level
		update_health_bar_color(player1_health_bar, player1_health)

	# Update Player 2 health bar
	if player2_health_bar:
		player2_health_bar.value = player2_health
		# Change color based on health level
		update_health_bar_color(player2_health_bar, player2_health)

func update_health_bar_color(health_bar: ProgressBar, health: int) -> void:
	# Get the style box for the progress bar
	var stylebox = health_bar.get_theme_stylebox("fill")

	# Change color based on health percentage
	if health > 60:
		# Green - healthy
		stylebox.bg_color = Color(0.2, 0.8, 0.2, 1.0)
	elif health > 30:
		# Yellow/Orange - warning
		stylebox.bg_color = Color(0.9, 0.7, 0.2, 1.0)
	else:
		# Red - critical
		stylebox.bg_color = Color(0.9, 0.2, 0.2, 1.0)

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
