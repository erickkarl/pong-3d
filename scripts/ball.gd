extends RigidBody3D

class_name Ball

@export var initial_speed = 15.0
@export var speed_increase_per_hit = 2

const ballHitSFX = preload("res://assets/sfx/ballHitSFX.mp3")

var game_manager: Node
var last_collision_body: Node = null
var collision_cooldown: float = 0.0
var hit_sound: AudioStreamPlayer3D

func _ready() -> void:
	# Disable gravity
	gravity_scale = 0.0

	# Set physics properties
	mass = 1.0
	linear_damp = 0.0
	angular_damp = 0.0

	# Create physics material for perfect bounce - CRITICAL for preserving energy
	var physics_material = PhysicsMaterial.new()
	physics_material.bounce = 1.0 # Perfect bounce - no energy loss
	physics_material.friction = 0.0 # No friction
	physics_material_override = physics_material

	# Make sure continuous collision detection is enabled
	continuous_cd = true

	# Enable contact monitoring (required for collision signals)
	contact_monitor = true
	max_contacts_reported = 4

	# CRITICAL: Unlock all axes - make sure the ball can move in all directions
	axis_lock_linear_x = false
	axis_lock_linear_y = false
	axis_lock_linear_z = true # Lock Z since we're playing in 2D plane

	# Connect the collision signal
	body_entered.connect(_on_body_entered)

	# Connect to game manager if it exists
	game_manager = get_node_or_null("/root/Game/GameManager")

	# Set up ball hit sound effect
	hit_sound = AudioStreamPlayer3D.new()
	add_child(hit_sound)
	hit_sound.stream = ballHitSFX
	hit_sound.volume_db = 0 # Adjust volume as needed

	# Start the ball after a short delay
	await get_tree().create_timer(1.0).timeout
	launch_ball()

func launch_ball() -> void:
	# Random direction (left or right) - ensure X velocity is never zero
	var x_direction = 1.0 if randf() > 0.5 else -1.0 # Always go left or right
	var y_direction = randf_range(-0.5, 0.5)
	var direction = Vector3(x_direction, y_direction, 0).normalized()
	linear_velocity = direction * initial_speed

func _physics_process(_delta: float) -> void:
	# Update collision cooldown
	if collision_cooldown > 0:
		collision_cooldown -= _delta

	# Keep rotation for visual effect (speed up rotation with ball speed)
	var rotation_speed = 0.1 * (linear_velocity.length() / initial_speed)
	rotate(Vector3(0, 1, 0), rotation_speed * _delta * PI)

func _on_body_entered(body: Node) -> void:
	# Prevent multiple rapid collisions with the same object
	if collision_cooldown > 0 and last_collision_body == body:
		return

	# Play hit sound effect for any collision
	hit_sound.play()

	# Check if the body's parent is a Player (since we're hitting the CollisionBody child)
	var player = null
	if body.get_parent() and body.get_parent() is Player:
		player = body.get_parent()

	# Or check if the body itself is a Player
	if body is Player:
		player = body

	# Check for player collision FIRST (before checking for StaticBody3D)
	if player:
		# Get current speed before any modifications
		var current_speed = linear_velocity.length()

		# Reverse X direction
		linear_velocity.x = - linear_velocity.x

		# Add some variation based on where it hit the paddle
		var hit_position = position.y - player.position.y
		print(hit_position)
		var bounce_angle = hit_position * 0.3 # Adjust angle based on hit position
		linear_velocity.y += bounce_angle

		# Increase speed and normalize direction
		var new_speed = current_speed * speed_increase_per_hit
		linear_velocity = linear_velocity.normalized() * new_speed

		# Set cooldown to prevent multiple rapid hits
		last_collision_body = body
		collision_cooldown = 0.2 # 200ms cooldown
		return

	# Check if it's a wall (StaticBody3D that's not a player's CollisionBody)
	if body is StaticBody3D and body.name == "ArenaWalls":
		# Reverse Y direction (top/bottom walls)
		linear_velocity.y = - linear_velocity.y

		# Set cooldown to prevent multiple rapid hits
		last_collision_body = body
		collision_cooldown = 0.1 # 100ms cooldown for walls
		return

func reset_ball() -> void:
	# Reset position and velocity
	position = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	# Launch again after a short delay
	await get_tree().create_timer(2.0).timeout
	launch_ball()
