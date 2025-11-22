extends CharacterBody3D
class_name Ball
## Ball with perfect bounce physics and collision cooldown to prevent double-hits.

const BALL_HIT_SFX := preload("res://assets/sfx/ballHitSFX.mp3")

signal paddle_hit(player_number: int)

@export var initial_speed: float = 40.0

var last_collision_body: Node = null
var collision_cooldown: float = 0.0
var hit_sound: AudioStreamPlayer3D

var last_speed: float = 0.0
var last_hit_player: int = 0  # 0 = nenhum, 1 = player1, 2 = player2

func _ready() -> void:
	# CharacterBody3D doesn't use gravity_scale/mass/etc like RigidBody3D
	# We just need to ensure it's set up for movement
	motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
	wall_min_slide_angle = 0

	# Lock Z to keep in plane (though move_and_collide respects velocity, so just don't give it Z velocity)
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
	velocity = direction * initial_speed
	last_speed = initial_speed

func _physics_process(delta: float) -> void:
	if collision_cooldown > 0:
		collision_cooldown -= delta

	# Track speed before collision
	last_speed = velocity.length()
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		_handle_collision(collision)

	var rotation_speed: float = GameConstants.BALL_ROTATION_SPEED * (velocity.length() / initial_speed)
	rotate(Vector3(0, 1, 0), rotation_speed * delta * PI)

func _handle_collision(collision: KinematicCollision3D) -> void:
	var collider = collision.get_collider()
	
	if not can_process_collision(collider):
		return

	# Check if it's a player (Paddle)
	# The collider is likely the StaticBody3D child of the Player node
	var parent = collider.get_parent()
	if parent is Player:
		# Identify which player hit the ball
		var player_number: int = _identify_player_number(parent)
		if player_number > 0:
			last_hit_player = player_number
			paddle_hit.emit(player_number)
		parent.collision_component.handle_ball_collision(self)
	else:
		# Standard bounce for walls
		velocity = velocity.bounce(collision.get_normal())
		play_hit_sound()
		set_collision_cooldown(collider, GameConstants.COLLISION_COOLDOWN_DURATION)

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
	velocity = Vector3.ZERO
	last_hit_player = 0
	
	await get_tree().create_timer(GameConstants.BALL_RESET_DELAY).timeout
	launch_ball()

## Identifies player number (1 or 2) based on position or name
func _identify_player_number(player: Player) -> int:
	# Player1 is typically on the left (negative X), Player2 on the right (positive X)
	if player.position.x < 0:
		return 1
	elif player.position.x > 0:
		return 2
	return 0
