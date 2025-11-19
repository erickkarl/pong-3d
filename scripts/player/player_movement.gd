extends Node
class_name PlayerMovement
## Handles player movement input and boundary constraints.
##
## This component manages keyboard input for paddle movement and ensures
## the paddle stays within the arena boundaries.

## Reference to the parent player node
var player: Node3D

## Movement keys
var move_up_key: Key
var move_down_key: Key

## Movement speed
var speed: float

## Vertical movement boundaries
var min_y_position: float
var max_y_position: float

## Sets up the movement component with the player reference.
func initialize(p_player: Node3D, p_move_up_key: Key, p_move_down_key: Key, p_speed: float) -> void:
	player = p_player
	move_up_key = p_move_up_key
	move_down_key = p_move_down_key
	speed = p_speed

## Calculates and sets movement boundaries based on arena size.
##
## @param arena: The arena node containing boundary information
func setup_movement_bounds(arena: Arena) -> void:
	if not arena:
		push_warning("PlayerMovement: Arena is null, cannot setup bounds")
		return

	# Calculate bounds: arena walls are at ±arena_height/2
	# Subtract paddle half-height to keep paddle center inside bounds
	var arena_top: float = arena.arena_height / 2.0
	var arena_bottom: float = -arena.arena_height / 2.0

	max_y_position = arena_top - GameConstants.PADDLE_HALF_HEIGHT
	min_y_position = arena_bottom + GameConstants.PADDLE_HALF_HEIGHT

## Processes movement input and returns whether the player is moving.
##
## @param delta: Time delta for framerate-independent movement
## @return: Dictionary with keys 'moving_up', 'moving_down', and 'is_moving'
func process_movement(delta: float) -> Dictionary:
	var result: Dictionary = {
		"moving_up": false,
		"moving_down": false,
		"is_moving": false
	}
	
	# Framerate-independent movement (normalized to 60 FPS)
	var movement_amount: float = speed * delta * 60.0

	if Input.is_key_pressed(move_up_key):
		player.position.y += movement_amount
		result.moving_up = true
		result.is_moving = true

	if Input.is_key_pressed(move_down_key):
		player.position.y -= movement_amount
		result.moving_down = true
		result.is_moving = true

	# Clamp position to boundaries
	player.position.y = clamp(player.position.y, min_y_position, max_y_position)

	return result
