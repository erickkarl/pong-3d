extends MeshInstance3D
## Simple rotating planet decoration for the main menu.
##
## Provides a slow rotation effect for visual appeal.

@export var rotation_speed: float = 0.1

func _process(delta: float) -> void:
	rotate_y(rotation_speed * delta)
