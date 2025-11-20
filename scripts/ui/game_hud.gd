extends CanvasLayer
class_name GameHUD
## Displays player health bars and game over panel.

@onready var player1_health_bar: ProgressBar = $HealthBarContainer/Player1Container/HealthBar
@onready var player2_health_bar: ProgressBar = $HealthBarContainer/Player2Container/HealthBar
@onready var game_over_panel: Panel = $GameOverPanel
@onready var winner_label: Label = $GameOverPanel/VBoxContainer/WinnerLabel

var game_manager: GameManager

func _ready() -> void:
	game_manager = get_node_or_null("../GameManager")

	if game_manager:
		game_manager.health_changed.connect(_on_health_changed)
		game_manager.game_over.connect(_on_game_over)

	if game_over_panel:
		game_over_panel.visible = false

	update_health(GameConstants.INITIAL_HEALTH, GameConstants.INITIAL_HEALTH)

func _on_health_changed(player1_health: int, player2_health: int) -> void:
	update_health(player1_health, player2_health)

func update_health(player1_health: int, player2_health: int) -> void:
	if player1_health_bar:
		player1_health_bar.value = player1_health
		update_health_bar_color(player1_health_bar, player1_health)

	if player2_health_bar:
		player2_health_bar.value = player2_health
		update_health_bar_color(player2_health_bar, player2_health)

## Changes health bar color based on thresholds (green > yellow > red).
func update_health_bar_color(health_bar: ProgressBar, health: int) -> void:
	var stylebox: StyleBox = health_bar.get_theme_stylebox("fill")
	if not stylebox is StyleBoxFlat:
		return

	var style := stylebox as StyleBoxFlat

	if health > GameConstants.HEALTH_THRESHOLD_HEALTHY:
		style.bg_color = GameConstants.HEALTH_COLOR_HEALTHY
	elif health > GameConstants.HEALTH_THRESHOLD_WARNING:
		style.bg_color = GameConstants.HEALTH_COLOR_WARNING
	else:
		style.bg_color = GameConstants.HEALTH_COLOR_CRITICAL

func _on_game_over(winner: int) -> void:
	if game_over_panel:
		game_over_panel.visible = true

	if winner_label:
		winner_label.text = "Player " + str(winner) + " Wins!"

func _on_main_menu_button_pressed() -> void:
	SceneManager.load_main_menu()

func _on_restart_button_pressed() -> void:
	if game_manager:
		game_manager.reset_game()

	if game_over_panel:
		game_over_panel.visible = false
