extends Node
class_name PlayerEffects
## Manages player visual and audio effects.
##
## This component handles particle effects (exhaust flames) and sound effects
## (engine flare sounds) that respond to player movement.

const FIRE_ANIMATION := preload("res://assets/fx/exhaust_flame_vfx.tscn")
const FLARE_SFX := preload("res://assets/sfx/flareSFX.mp3")

## Reference to the parent player node
var player: Node3D

## Particle effects
var top_exhaust: GPUParticles3D
var bottom_exhaust: GPUParticles3D

## Audio
var flare_sound: AudioStreamPlayer3D

## Initializes the effects component with the player reference.
##
## Sets up particle effects and audio nodes as children of the player.
## @param p_player: The parent player node to attach effects to
func initialize(p_player: Node3D) -> void:
	player = p_player
	_setup_particle_effects()
	_setup_audio()

## Sets up the exhaust particle effects at the top and bottom of the paddle.
func _setup_particle_effects() -> void:
	# Bottom exhaust
	bottom_exhaust = FIRE_ANIMATION.instantiate()
	player.add_child(bottom_exhaust)
	bottom_exhaust.position = Vector3(0, -GameConstants.PADDLE_EXHAUST_OFFSET, 0)
	if bottom_exhaust is GPUParticles3D:
		bottom_exhaust.emitting = true
		bottom_exhaust.local_coords = true
		bottom_exhaust.visible = false  # Start invisible

	# Top exhaust
	top_exhaust = FIRE_ANIMATION.instantiate()
	player.add_child(top_exhaust)
	top_exhaust.position = Vector3(0, GameConstants.PADDLE_EXHAUST_OFFSET, 0)
	top_exhaust.rotation_degrees = Vector3(270, 0, 0)
	if top_exhaust is GPUParticles3D:
		top_exhaust.emitting = true
		top_exhaust.local_coords = true
		top_exhaust.visible = false  # Start invisible

## Sets up the engine flare sound effect.
func _setup_audio() -> void:
	flare_sound = AudioStreamPlayer3D.new()
	player.add_child(flare_sound)
	flare_sound.stream = FLARE_SFX

	# Enable looping on the audio stream
	if flare_sound.stream is AudioStreamMP3:
		flare_sound.stream.loop = true

	flare_sound.volume_db = 0

## Updates visual and audio effects based on movement state.
##
## Shows/hides exhaust effects and plays/stops engine sound based on
## which direction the player is moving.
## @param movement_state: Dictionary with 'moving_up', 'moving_down', and 'is_moving' keys
func update_effects(movement_state: Dictionary) -> void:
	# Update particle visibility based on movement direction
	if bottom_exhaust:
		bottom_exhaust.visible = movement_state.get("moving_up", false)
	if top_exhaust:
		top_exhaust.visible = movement_state.get("moving_down", false)

	# Play or stop flare sound based on movement
	if not flare_sound:
		return
		
	var is_moving: bool = movement_state.get("is_moving", false)
	if is_moving:
		if not flare_sound.playing:
			flare_sound.play()
	else:
		if flare_sound.playing:
			flare_sound.stop()
