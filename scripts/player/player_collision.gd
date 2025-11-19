extends Node
class_name PlayerCollision
## Handles ball collision detection and reflection physics for paddles.

var player: Node3D
var speed_multiplier: float

func initialize(player_node: Node3D, multiplier: float) -> void:
	player = player_node
	speed_multiplier = multiplier

## Creates Area3D to detect ball entering paddle collision zone.
func setup_collision_detection(collision_body: StaticBody3D) -> void:
	if not collision_body:
		push_error("PlayerCollision: collision_body is null")
		return

	var collision_shape := collision_body.get_node_or_null("CollisionShape3D") as CollisionShape3D
	if not collision_shape:
		push_error("PlayerCollision: CollisionShape3D not found on collision_body")
		return

	CollisionUtils.setup_ball_detection_area(
		collision_body,
		collision_shape,
		_on_ball_entered,
		[]
	)

func _on_ball_entered(body: Node3D) -> void:
	if body is Ball:
		handle_ball_collision(body)

## Calculates reflection angle based on hit position and applies speed multiplier.
func handle_ball_collision(ball: Ball) -> void:
	if not ball.can_process_collision(player):
		return

	ball.play_hit_sound()
	var current_speed: float = ball.linear_velocity.length()

	# Normalize hit position: -1 (bottom) to 1 (top)
	var hit_position: float = ball.position.y - player.position.y
	var normalized_hit: float = clamp(
		hit_position / GameConstants.PADDLE_HALF_HEIGHT,
		-1.0,
		1.0
	)

	var x_direction: float = -1.0 if ball.linear_velocity.x > 0 else 1.0
	var direction: Vector3 = Vector3(x_direction, normalized_hit, 0).normalized()

	var new_speed: float = current_speed * speed_multiplier
	ball.linear_velocity = direction * new_speed

	ball.set_collision_cooldown(player, GameConstants.COLLISION_COOLDOWN_DURATION)
