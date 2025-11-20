extends Node
## Global autoload singleton for scene transitions.

const MAIN_MENU := "res://scenes/main_menu.tscn"
const GAME := "res://scenes/game.tscn"

func load_main_menu() -> void:
	_change_scene(MAIN_MENU)

func load_game() -> void:
	_change_scene(GAME)

func restart_current_scene() -> void:
	get_tree().reload_current_scene()

func _change_scene(scene_path: String) -> void:
	var error: Error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("Failed to load scene: %s (Error code: %d)" % [scene_path, error])
