extends Node
class_name PlayerCollision
## Handles player paddle collision with the ball.
##
## This component manages collision detection setup and ball physics calculations
## when the ball hits the paddle.

## Reference to the parent player node
var player: Node3D

## Speed multiplier to apply to ball on collision
var speed_multiplier: float

## Initializes the collision component.
##
## @param p_player: The parent player node
## @param p_speed_multiplier: Multiplier to apply to ball speed on hit
func initialize(p_player: Node3D, p_speed_multiplier: float) -> void:
	player = p_player
	speed_multiplier = p_speed_multiplier

## Sets up collision detection on the player's collision body.
##
## Creates an Area3D to detect when the ball enters the paddle's collision zone.
## @param collision_body: The StaticBody3D representing the paddle's physics body
func setup_collision_detection(collision_body: StaticBody3D) -> void:
	if not collision_body:
		push_error("PlayerCollision: collision_body is null")
		return

	# Get the collision shape from the static body
	var collision_shape := collision_body.get_node_or_null("CollisionShape3D") as CollisionShape3D
	if not collision_shape:
		push_error("PlayerCollision: CollisionShape3D not found on collision_body")
		return

	# Use CollisionUtils to setup the detection area
	CollisionUtils.setup_ball_detection_area(
		collision_body,
		collision_shape,
		_on_ball_entered,
		[]
	)

## Callback when the ball enters the paddle's collision area.
##
## @param body: The node that entered the collision area
func _on_ball_entered(body: Node3D) -> void:
	if body is Ball:
		handle_ball_collision(body)

## Handles the physics calculations when the ball collides with the paddle.
##
## Calculates the reflection angle based on where the ball hits the paddle
## and applies a speed multiplier to gradually increase game pace.
## @param ball: The ball that collided with the paddle
func handle_ball_collision(ball: Ball) -> void:
	# Check if collision should be processed (cooldown check)
	if not ball.can_process_collision(player):
		return

	# Play hit sound effect
	ball.play_hit_sound()

	# Get current speed before any modifications
	var current_speed: float = ball.linear_velocity.length()

	# Calculate normalized hit position (-1 to 1, where -1 is bottom, 1 is top)
	var hit_position: float = ball.position.y - player.position.y
	var normalized_hit: float = clamp(
		hit_position / GameConstants.PADDLE_HALF_HEIGHT,
		-1.0,
		1.0
	)

	# Determine direction based on which side we're hitting from
	var x_direction: float = -1.0 if ball.linear_velocity.x > 0 else 1.0

	# Create new direction: X goes toward opponent, Y is based on hit position
	# The more toward the top of paddle, the more positive Y (upward)
	# The more toward the bottom, the more negative Y (downward)
	var direction: Vector3 = Vector3(x_direction, normalized_hit, 0).normalized()

	# Apply speed with multiplier
	var new_speed: float = current_speed * speed_multiplier
	ball.linear_velocity = direction * new_speed

	# Set cooldown to prevent multiple rapid hits
	ball.set_collision_cooldown(player, GameConstants.COLLISION_COOLDOWN_DURATION)
