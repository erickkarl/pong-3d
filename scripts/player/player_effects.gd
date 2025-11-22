extends Node
class_name PlayerEffects
## Manages particle effects and audio that respond to movement.


const FIRE_ANIMATION := preload("res://assets/fx/flame/exhaust_flame_vfx.tscn")
const FLARE_SFX := preload("res://assets/sfx/flareSFX.mp3")

var player: Node3D
var top_exhaust: GPUParticles3D
var bottom_exhaust: GPUParticles3D
var flare_sound: AudioStreamPlayer3D

func initialize(player_node: Node3D) -> void:
	player = player_node
	_setup_particle_effects()
	_setup_audio()

func _setup_particle_effects() -> void:
	bottom_exhaust = FIRE_ANIMATION.instantiate()
	player.add_child(bottom_exhaust)
	bottom_exhaust.position = Vector3(0, -GameConstants.PADDLE_EXHAUST_OFFSET, 0)
	if bottom_exhaust is GPUParticles3D:
		bottom_exhaust.emitting = true
		bottom_exhaust.local_coords = true
		bottom_exhaust.visible = false

	top_exhaust = FIRE_ANIMATION.instantiate()
	player.add_child(top_exhaust)
	top_exhaust.position = Vector3(0, GameConstants.PADDLE_EXHAUST_OFFSET, 0)
	top_exhaust.rotation_degrees = Vector3(270, 0, 0)
	if top_exhaust is GPUParticles3D:
		top_exhaust.emitting = true
		top_exhaust.local_coords = true
		top_exhaust.visible = false

func _setup_audio() -> void:
	flare_sound = AudioStreamPlayer3D.new()
	player.add_child(flare_sound)
	flare_sound.stream = FLARE_SFX
	
	if flare_sound.stream is AudioStreamMP3:
		flare_sound.stream.loop = true
	
	flare_sound.volume_db = GameConstants.SFX_VOLUME_DB

## Toggles particle visibility and audio based on movement direction.
func update_effects(movement_state: Dictionary) -> void:
	if bottom_exhaust:
		bottom_exhaust.visible = movement_state.get("moving_up", false)
	if top_exhaust:
		top_exhaust.visible = movement_state.get("moving_down", false)

	if not flare_sound:
		return

	var is_moving: bool = movement_state.get("is_moving", false)
	if is_moving:
		if not flare_sound.playing:
			flare_sound.play()
	else:
		if flare_sound.playing:
			flare_sound.stop()
