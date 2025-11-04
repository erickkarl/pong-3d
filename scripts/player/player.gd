extends Node3D

class_name Player

@export
var move_down_key = KEY_DOWN

@export
var move_up_key = KEY_UP

@export
var speed = 1

@export
var max_y_position = 15.0

@export
var min_y_position = -15.0

const fireAnimation = preload("res://assets/fx/exhaust_flame_vfx.tscn")
const flareSFX = preload("res://assets/sfx/flareSFX.mp3")

var top_exhaust: GPUParticles3D
var bottom_exhaust: GPUParticles3D
var flare_sound: AudioStreamPlayer3D
var is_moving_state = false  # Track movement state for looping

func _ready() -> void:
	# Set up physics material for the collision body
	var collision_body = get_node_or_null("CollisionBody")
	if collision_body and collision_body is StaticBody3D:
		var physics_material = PhysicsMaterial.new()
		physics_material.bounce = 1.0  # Perfect bounce
		physics_material.friction = 0.0  # No friction
		collision_body.physics_material_override = physics_material

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
	# Connect finished signal to restart looping when moving
	flare_sound.finished.connect(_on_flare_sound_finished)
	flare_sound.volume_db = 0  # Adjust volume as needed


func _on_flare_sound_finished() -> void:
	# Restart the sound if we're still moving
	if is_moving_state:
		flare_sound.play()


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

	# Update movement state
	is_moving_state = is_moving

	# Play or stop flare sound based on movement
	if is_moving:
		if not flare_sound.playing:
			flare_sound.play()
	else:
		if flare_sound.playing:
			flare_sound.stop()

	# Clamp position to boundaries
	new_position.y = clamp(new_position.y, min_y_position, max_y_position)
	position = new_position
	
	
	