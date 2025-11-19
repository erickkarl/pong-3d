extends Node3D
## Main menu screen handler.
##
## Handles navigation from the main menu to the game or exiting the application.

func _on_play_pressed() -> void:
	SceneManager.load_game()

func _on_exit_pressed() -> void:
	get_tree().quit()
