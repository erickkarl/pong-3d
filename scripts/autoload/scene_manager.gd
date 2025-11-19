extends Node
## Global scene manager for handling scene transitions.
##
## This autoload singleton provides centralized scene management with consistent
## scene paths and transition methods. Use SceneManager.load_game() or
## SceneManager.load_main_menu() instead of hardcoding scene paths.

# ============================================================================
# SCENE PATHS
# ============================================================================

const MAIN_MENU := "res://scenes/main_menu.tscn"
const GAME := "res://scenes/game.tscn"

# ============================================================================
# PUBLIC METHODS
# ============================================================================

## Loads the main menu scene.
##
## Call this when the player wants to return to the main menu from the game
## or when exiting other screens.
func load_main_menu() -> void:
	_change_scene(MAIN_MENU)

## Loads the main game scene.
##
## Call this when starting a new game from the main menu.
func load_game() -> void:
	_change_scene(GAME)

## Restarts the current scene.
##
## Useful for quick restart functionality without needing to know
## which scene is currently active.
func restart_current_scene() -> void:
	get_tree().reload_current_scene()

# ============================================================================
# PRIVATE METHODS
# ============================================================================

func _change_scene(scene_path: String) -> void:
	var error: Error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("Failed to load scene: %s (Error code: %d)" % [scene_path, error])
