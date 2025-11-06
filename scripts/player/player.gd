extends Node3D

class_name Player

@export
var move_down_key = KEY_DOWN

@export
var move_up_key = KEY_UP

@export
var speed = 1

var speedMultiplier = 1.1

const fireAnimation = preload("res://assets/fx/exhaust_flame_vfx.tscn")
const flareSFX = preload("res://assets/sfx/flareSFX.mp3")

var top_exhaust: GPUParticles3D
var bottom_exhaust: GPUParticles3D
var flare_sound: AudioStreamPlayer3D
var max_y_position: float
var min_y_position: float
var arena: Arena

func _ready() -> void:
	# Find the arena to get its bounds
	arena = get_node_or_null("../Arena")
	if not arena:
		arena = get_tree().get_first_node_in_group("arena") as Arena
	
	# Calculate movement bounds based on arena and paddle size
	setup_movement_bounds()
	
	# Set up physics material for the collision body
	var collision_body = get_node_or_null("CollisionBody")
	if collision_body and collision_body is StaticBody3D:
		var physics_material = PhysicsMaterial.new()
		physics_material.bounce = 1.0  # Perfect bounce
		physics_material.friction = 0.0  # No friction
		collision_body.physics_material_override = physics_material
		
		# Set up Area3D to detect ball collisions
		setup_collision_detection(collision_body)

	bottom_exhaust = fireAnimation.instantiate()
	add_child(bottom_exhaust)
	bottom_exhaust.position = Vector3(0, -8.450854, 0)
	if bottom_exhaust is GPUParticles3D:
		bottom_exhaust.emitting = true
		bottom_exhaust.local_coords = true

	top_exhaust = fireAnimation.instantiate()
	add_child(top_exhaust)
	top_exhaust.position = Vector3(0, 8.450854, 0)
	top_exhaust.rotation_degrees = Vector3(270, 0, 0)
	if top_exhaust is GPUParticles3D:
		top_exhaust.emitting = true
		top_exhaust.local_coords = true

	# Set up flare sound effect
	flare_sound = AudioStreamPlayer3D.new()
	add_child(flare_sound)
	flare_sound.stream = flareSFX
	
	# Enable looping on the audio stream
	if flare_sound.stream is AudioStreamMP3:
		flare_sound.stream.loop = true
	
	flare_sound.volume_db = 0  # Adjust volume as needed

func setup_movement_bounds() -> void:
	# Paddle height is 17 units, so half-height is 8.5
	var paddle_half_height = 8.5
	
	if arena:
		# Calculate bounds: arena walls are at ±arena_height/2
		# Subtract paddle half-height to keep paddle center inside bounds
		var arena_top = arena.arena_height / 2.0
		var arena_bottom = -arena.arena_height / 2.0
		
		max_y_position = arena_top - paddle_half_height
		min_y_position = arena_bottom + paddle_half_height

func _process(_delta: float) -> void:
	var new_position = position
	var is_moving = false

	if(Input.is_key_pressed(move_up_key)):
		new_position.y += speed
		bottom_exhaust.visible = true
		is_moving = true
	else:
		bottom_exhaust.visible = false

	if(Input.is_key_pressed(move_down_key)):
		new_position.y -= speed
		top_exhaust.visible = true
		is_moving = true
	else:
		top_exhaust.visible = false

	# Play or stop flare sound based on movement
	# With loop enabled, the sound will automatically loop when playing
	if is_moving:
		if not flare_sound.playing:
			flare_sound.play()
	else:
		if flare_sound.playing:
			flare_sound.stop()

	# Clamp position to boundaries
	new_position.y = clamp(new_position.y, min_y_position, max_y_position)
	position = new_position

func setup_collision_detection(collision_body: StaticBody3D) -> void:
	# Create Area3D to detect when ball enters
	var area = Area3D.new()
	area.name = "BallDetectionArea"
	collision_body.add_child(area)
	
	# Copy the collision shape from the static body
	var collision_shape = collision_body.get_node_or_null("CollisionShape3D")
	if collision_shape:
		var shape = collision_shape.shape
		if shape:
			var area_shape = CollisionShape3D.new()
			area_shape.shape = shape
			area.add_child(area_shape)
	
	# Connect to detect ball
	area.body_entered.connect(_on_ball_entered)
	
	# Set collision layer/mask to detect ball
	area.collision_layer = 0
	area.collision_mask = 2  # Layer 2 is the ball

func _on_ball_entered(body: Node3D) -> void:
	if body is Ball:
		handle_ball_collision(body)

func handle_ball_collision(ball: Ball) -> void:
	# Check if collision should be processed
	if not ball.can_process_collision(self):
		return

	# Play hit sound effect
	ball.play_hit_sound()

	# Get current speed before any modifications
	var current_speed = ball.linear_velocity.length()
	
	# Calculate normalized hit position (-1 to 1, where -1 is bottom, 1 is top)
	# Paddle height is 17 units, so half-height is 8.5
	var paddle_half_height = 8.5
	var hit_position = ball.position.y - position.y
	var normalized_hit = clamp(hit_position / paddle_half_height, -1.0, 1.0)
	
	# Determine direction based on which side we're hitting from
	var x_direction = -1.0 if ball.linear_velocity.x > 0 else 1.0
	
	# Create new direction: X goes toward opponent, Y is based on hit position
	# The more toward the top of paddle, the more positive Y (upward)
	# The more toward the bottom, the more negative Y (downward)
	var direction = Vector3(x_direction, normalized_hit, 0).normalized()
	
	# Apply speed with 1.1x multiplier
	var new_speed = current_speed * speedMultiplier
	ball.linear_velocity = direction * new_speed

	# Set cooldown to prevent multiple rapid hits
	ball.set_collision_cooldown(self, 0.1)  # 100ms cooldown
	