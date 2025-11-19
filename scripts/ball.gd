extends RigidBody3D
class_name Ball
## Ball with perfect bounce physics and collision cooldown to prevent double-hits.

const BALL_HIT_SFX := preload("res://assets/sfx/ballHitSFX.mp3")

@export var initial_speed: float = 15.0

var last_collision_body: Node = null
var collision_cooldown: float = 0.0
var hit_sound: AudioStreamPlayer3D

func _ready() -> void:
	gravity_scale = 0.0
	mass = 1.0
	linear_damp = 0.0
	angular_damp = 0.0

	physics_material_override = PhysicsUtils.create_bouncy_material()
	continuous_cd = true
	contact_monitor = true
	max_contacts_reported = 4

	# Unlock X/Y for 2D movement, lock Z to keep in plane
	axis_lock_linear_x = false
	axis_lock_linear_y = false
	axis_lock_linear_z = true

	hit_sound = AudioStreamPlayer3D.new()
	add_child(hit_sound)
	hit_sound.stream = BALL_HIT_SFX
	hit_sound.volume_db = GameConstants.SFX_VOLUME_DB

	await get_tree().create_timer(GameConstants.BALL_LAUNCH_DELAY).timeout
	launch_ball()

func launch_ball() -> void:
	var x_direction: float = 1.0 if randf() > 0.5 else -1.0
	var y_direction: float = randf_range(-0.5, 0.5)
	var direction: Vector3 = Vector3(x_direction, y_direction, 0).normalized()
	linear_velocity = direction * initial_speed

func _physics_process(delta: float) -> void:
	if collision_cooldown > 0:
		collision_cooldown -= delta

	var rotation_speed: float = GameConstants.BALL_ROTATION_SPEED * (linear_velocity.length() / initial_speed)
	rotate(Vector3(0, 1, 0), rotation_speed * delta * PI)

func can_process_collision(collider: Node) -> bool:
	if collision_cooldown > 0 and last_collision_body == collider:
		return false
	return true

func set_collision_cooldown(collider: Node, cooldown_time: float) -> void:
	last_collision_body = collider
	collision_cooldown = cooldown_time

func play_hit_sound() -> void:
	hit_sound.play()

func reset_ball() -> void:
	position = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	await get_tree().create_timer(GameConstants.BALL_RESET_DELAY).timeout
	launch_ball()
