extends RigidBody3D

class_name Ball

@export var initial_speed = 15.0

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

# Check if this collision should be processed (cooldown check)
func can_process_collision(collider: Node) -> bool:
	if collision_cooldown > 0 and last_collision_body == collider:
		return false
	return true

# Set collision cooldown and last collision body
func set_collision_cooldown(collider: Node, cooldown_time: float) -> void:
	last_collision_body = collider
	collision_cooldown = cooldown_time

# Play hit sound
func play_hit_sound() -> void:
	hit_sound.play()

func reset_ball() -> void:
	# Reset position and velocity
	position = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	# Launch again after a short delay
	await get_tree().create_timer(2.0).timeout
	launch_ball()
