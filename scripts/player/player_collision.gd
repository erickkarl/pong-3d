extends Node
class_name PlayerCollision
## Handles ball collision detection and reflection physics for paddles.

var player: Node3D
var speed_multiplier: float

func initialize(player_node: Node3D, multiplier: float) -> void:
	player = player_node
	speed_multiplier = multiplier

## Calculates reflection angle based on hit position and applies speed multiplier.
func handle_ball_collision(ball: Ball) -> void:
	ball.play_hit_sound()
	
	# Normalize hit position: -1 (bottom) to 1 (top)
	var hit_position: float = ball.position.y - player.position.y
	var normalized_hit: float = clamp(
		hit_position / GameConstants.PADDLE_HALF_HEIGHT,
		-1.0,
		1.0
	) * 2

	var x_direction: float = -1.0 if player.position.x > 0 else 1.0
	var direction: Vector3 = Vector3(x_direction, normalized_hit, 0).normalized()

	var new_speed: float = clamp(ball.last_speed * speed_multiplier, 0, GameConstants.MAX_BALL_SPEED)
	ball.last_speed = new_speed
	ball.velocity = direction * new_speed

	ball.set_collision_cooldown(player, GameConstants.COLLISION_COOLDOWN_DURATION)
