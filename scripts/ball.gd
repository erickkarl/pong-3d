extends RigidBody3D
## The ball in the Pong 3D game.
##
## Handles ball physics, collision detection, launching, and resetting.
## Uses perfect bounce physics to maintain constant energy throughout the game.

class_name Ball

# ============================================================================
# EXPORTS
# ============================================================================

@export var initial_speed: float = 15.0

# ============================================================================
# CONSTANTS
# ============================================================================

const BALL_HIT_SFX := preload("res://assets/sfx/ballHitSFX.mp3")

# ============================================================================
# STATE
# ============================================================================

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
	physics_material_override = PhysicsUtils.create_bouncy_material()

	# Make sure continuous collision detection is enabled
	continuous_cd = true

	# Enable contact monitoring (required for collision signals)
	contact_monitor = true
	max_contacts_reported = 4

	# CRITICAL: Unlock all axes - make sure the ball can move in all directions
	axis_lock_linear_x = false
	axis_lock_linear_y = false
	axis_lock_linear_z = true # Lock Z since we're playing in 2D plane

	# Set up ball hit sound effect
	hit_sound = AudioStreamPlayer3D.new()
	add_child(hit_sound)
	hit_sound.stream = BALL_HIT_SFX
	hit_sound.volume_db = 0

	# Start the ball after a short delay
	await get_tree().create_timer(GameConstants.BALL_LAUNCH_DELAY).timeout
	launch_ball()

func launch_ball() -> void:
	# Random direction (left or right) - ensure X velocity is never zero
	var x_direction: float = 1.0 if randf() > 0.5 else -1.0
	var y_direction: float = randf_range(-0.5, 0.5)
	var direction: Vector3 = Vector3(x_direction, y_direction, 0).normalized()
	linear_velocity = direction * initial_speed

func _physics_process(delta: float) -> void:
	# Update collision cooldown
	if collision_cooldown > 0:
		collision_cooldown -= delta

	# Keep rotation for visual effect (speed up rotation with ball speed)
	var rotation_speed: float = GameConstants.BALL_ROTATION_SPEED * (linear_velocity.length() / initial_speed)
	rotate(Vector3(0, 1, 0), rotation_speed * delta * PI)

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
	await get_tree().create_timer(GameConstants.BALL_RESET_DELAY).timeout
	launch_ball()
