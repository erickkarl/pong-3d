extends Node3D

func _on_play_pressed() -> void:
	SceneManager.load_game()

func _on_exit_pressed() -> void:
	get_tree().quit()
