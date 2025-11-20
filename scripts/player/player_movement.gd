extends Node
class_name PlayerMovement
## Handles keyboard input and boundary constraints for paddle movement.

var player: Node3D
var move_up_key: Key
var move_down_key: Key
var speed: float
var min_y_position: float
var max_y_position: float

func initialize(player_node: Node3D, up_key: Key, down_key: Key, movement_speed: float) -> void:
	player = player_node
	move_up_key = up_key
	move_down_key = down_key
	speed = movement_speed

## Sets bounds by subtracting paddle half-height from arena walls.
func setup_movement_bounds(arena: Arena) -> void:
	if not arena:
		push_warning("PlayerMovement: Arena is null, cannot setup bounds")
		return

	var arena_top: float = arena.arena_height / 2.0
	var arena_bottom: float = -arena.arena_height / 2.0

	max_y_position = arena_top - GameConstants.PADDLE_HALF_HEIGHT
	min_y_position = arena_bottom + GameConstants.PADDLE_HALF_HEIGHT

## Normalizes movement to 60 FPS for consistent speed across framerates.
func process_movement(delta: float) -> Dictionary:
	var result: Dictionary = {
		"moving_up": false,
		"moving_down": false,
		"is_moving": false
	}

	var movement_amount: float = speed * delta * GameConstants.TARGET_FPS

	if Input.is_key_pressed(move_up_key):
		player.position.y += movement_amount
		result.moving_up = true
		result.is_moving = true

	if Input.is_key_pressed(move_down_key):
		player.position.y -= movement_amount
		result.moving_down = true
		result.is_moving = true

	player.position.y = clamp(player.position.y, min_y_position, max_y_position)

	return result
