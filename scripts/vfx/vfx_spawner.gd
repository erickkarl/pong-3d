extends Node3D
class_name VFXSpawner
## Spawns powerup VFX after paddle hits in random positions between paddles.

const VFX_SCENE = preload("res://assets/fx/helling/helling.tscn")

var current_vfx: PowerupVFX = null
var ball: Ball

func _ready() -> void:
	# Aguardar um frame para garantir que a bola está pronta
	await get_tree().process_frame
	ball = get_node_or_null("../Ball") as Ball
	
	if ball:
		ball.paddle_hit.connect(_on_paddle_hit)
	else:
		push_error("VFXSpawner: Ball not found!")

func _on_paddle_hit(player_number: int) -> void:
	# Only spawn if no VFX currently exists
	if current_vfx and is_instance_valid(current_vfx):
		return
	
	spawn_vfx()

func spawn_vfx() -> void:
	if not VFX_SCENE:
		push_error("VFXSpawner: VFX scene not found")
		return
	
	# Create VFX instance
	var vfx_node = VFX_SCENE.instantiate()
	if not vfx_node:
		push_error("VFXSpawner: Failed to instantiate VFX scene")
		return
	
	# CORREÇÃO: Aumentar a quantidade de partículas e lifetime para ser mais visível
	var particles = vfx_node as GPUParticles3D
	if particles:
		particles.amount = 50  # Aumentar de 1 para 50
		particles.lifetime = 5.0  # Aumentar de 0.15 para 5.0 segundos
		particles.emitting = true
	
	# Create PowerupVFX wrapper
	var powerup_vfx = PowerupVFX.new()
	powerup_vfx.name = "PowerupVFX"
	
	# Add collision area
	var collision_area = Area3D.new()
	collision_area.name = "CollisionArea"
	collision_area.collision_layer = 0
	collision_area.collision_mask = 2  # Ball layer
	collision_area.monitoring = true  # Garantir que está monitorando
	powerup_vfx.add_child(collision_area)
	
	# Add VFX instance as child
	vfx_node.name = "VFXInstance"
	powerup_vfx.add_child(vfx_node)
	
	# Position randomly between paddles
	var random_x = randf_range(GameConstants.VFX_SPAWN_AREA_X_MIN, GameConstants.VFX_SPAWN_AREA_X_MAX)
	var random_y = randf_range(GameConstants.VFX_SPAWN_AREA_Y_MIN, GameConstants.VFX_SPAWN_AREA_Y_MAX)
	powerup_vfx.position = Vector3(random_x, random_y, 0)
	
	# Connect signal
	powerup_vfx.collected.connect(_on_vfx_collected)
	
	# Add to scene
	add_child(powerup_vfx)
	current_vfx = powerup_vfx

func _on_vfx_collected(player_number: int) -> void:
	current_vfx = null
