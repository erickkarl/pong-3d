extends Node3D
class_name PowerupVFX
## Manages individual powerup VFX with collision detection and effect application.

signal collected(player_number: int)

var collision_area: Area3D
var vfx_instance: Node3D

var game_manager: GameManager
var ball: Ball

func _ready() -> void:
	collision_area = get_node_or_null("CollisionArea") as Area3D
	vfx_instance = get_node_or_null("VFXInstance") as Node3D
	
	# CORREÇÃO: Caminho correto (PowerupVFX -> VFXSpawner -> Game -> GameManager/Ball)
	game_manager = get_node_or_null("../../GameManager") as GameManager
	ball = get_node_or_null("../../Ball") as Ball
	
	if collision_area:
		collision_area.body_entered.connect(_on_body_entered)
		collision_area.monitoring = true  # Garantir que está monitorando
		
		# Setup collision shape if not already set
		var collision_shape = collision_area.get_node_or_null("CollisionShape3D")
		if not collision_shape:
			collision_shape = CollisionShape3D.new()
			var sphere_shape = SphereShape3D.new()
			sphere_shape.radius = GameConstants.VFX_COLLISION_RADIUS
			collision_shape.shape = sphere_shape
			collision_area.add_child(collision_shape)

func _on_body_entered(body: Node3D) -> void:
	if body is Ball and ball:
		# Apply effect to the last player who hit the ball
		if ball.last_hit_player > 0 and game_manager:
			game_manager.heal_player(ball.last_hit_player, GameConstants.VFX_HEAL_AMOUNT)
			collected.emit(ball.last_hit_player)
		
		# Remove VFX after collection
		queue_free()

