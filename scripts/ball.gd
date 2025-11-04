extends RigidBody3D

class_name Ball

@export var initial_speed = 15.0
@export var max_speed = 25.0
@export var speed_increase_per_hit = 1.1

var game_manager: Node

func _ready() -> void:
	# Disable gravity
	gravity_scale = 0.0

	# Set physics properties
	mass = 1.0
	linear_damp = 0.0
	angular_damp = 0.0

	# Make sure continuous collision detection is enabled
	continuous_cd = true

	# Enable contact monitoring (required for collision signals)
	contact_monitor = true
	max_contacts_reported = 4

	# Connect the collision signal
	body_entered.connect(_on_body_entered)

	# Connect to game manager if it exists
	game_manager = get_node_or_null("/root/Game/GameManager")

	# Start the ball after a short delay
	await get_tree().create_timer(1.0).timeout
	launch_ball()

func launch_ball() -> void:
	# Random direction (left or right)
	print_debug("Launching ball")
	var direction = Vector3(randf_range(-1, 1), randf_range(-0.5, 0.5), 0).normalized()
	linear_velocity = direction * initial_speed

func _physics_process(_delta: float) -> void:
	# Clamp speed to max
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

	# Keep rotation for visual effect
	rotate(Vector3(0, 1, 0), 0.1 * _delta * PI)

func _on_body_entered(body: Node) -> void:
	# Increase speed when hitting paddles
	print_debug("Ball collided with: ", body.name, " Type: ", body.get_class())
	print_debug("Parent: ", body.get_parent().name if body.get_parent() else "No parent")
	print_debug("Parent type: ", body.get_parent().get_class() if body.get_parent() else "N/A")
	print_debug("Is parent a Player?: ", body.get_parent() is Player if body.get_parent() else false)

	# Check if the body's parent is a Player (since we're hitting the CollisionBody child)
	var player = body.get_parent() if body.get_parent() is Player else null

	# Or check if the body itself is a Player
	if body is Player:
		player = body
		print_debug("Body itself is a Player!")

	# Check for player collision FIRST (before checking for StaticBody3D)
	if player:
		print_debug("Hit a player paddle!")
		# Reverse X direction and increase speed
		linear_velocity.x = -linear_velocity.x * speed_increase_per_hit
		print_debug("Ball speed increased to: ", linear_velocity.length())
		print_debug("Ball velocity: ", linear_velocity)

		# Add some variation based on where it hit the paddle
		var hit_position = position.y - player.position.y
		var bounce_angle = hit_position * 0.3 # Adjust angle based on hit position
		linear_velocity.y += bounce_angle
		return

	# Check if it's a wall (StaticBody3D that's not a player's CollisionBody)
	if body is StaticBody3D and body.name == "ArenaWalls":
		print_debug("Ball hit a wall")
		# Reverse Y direction (top/bottom walls)
		linear_velocity.y = -linear_velocity.y
		print_debug("Ball velocity after wall bounce: ", linear_velocity)
		return

	print_debug("Hit something else (other object)")

func reset_ball() -> void:
	# Reset position and velocity
	position = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	# Launch again after a short delay
	await get_tree().create_timer(2.0).timeout
	launch_ball()
