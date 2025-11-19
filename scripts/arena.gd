extends Node3D
## The game arena with top and bottom walls.
##
## Creates the playing field boundaries and handles ball collision detection
## with the walls.

class_name Arena

# ============================================================================
# EXPORTS
# ============================================================================

@export var arena_width: float = 100.0
@export var arena_height: float = 50.0
@export var wall_thickness: float = 2.0

func _ready() -> void:
	# Add to group so players can find it
	add_to_group("arena")
	create_walls()

func create_walls() -> void:
	# Top wall
	create_wall(
		Vector3(0, arena_height / 2, 0),
		Vector3(arena_width, wall_thickness, 2)
	)

	# Bottom wall
	create_wall(
		Vector3(0, -arena_height / 2, 0),
		Vector3(arena_width, wall_thickness, 2)
	)

func create_wall(pos: Vector3, size: Vector3) -> void:
	var wall := StaticBody3D.new()
	wall.position = pos
	wall.name = "ArenaWalls"

	# Create physics material for perfect bounce
	wall.physics_material_override = PhysicsUtils.create_bouncy_material()

	var collision_shape := CollisionShape3D.new()
	var box_shape := BoxShape3D.new()
	box_shape.size = size

	collision_shape.shape = box_shape
	wall.add_child(collision_shape)

	# Optional: Add visual mesh for debugging
	var mesh_instance := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	box_mesh.size = size
	mesh_instance.mesh = box_mesh

	# Make walls slightly transparent
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.2, 0.2, 0.8, 0.3)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_instance.material_override = material

	wall.add_child(mesh_instance)
	
	# Set up Area3D to detect ball collisions
	setup_wall_collision_detection(wall, collision_shape)

	add_child(wall)

func setup_wall_collision_detection(wall: StaticBody3D, collision_shape_node: CollisionShape3D) -> void:
	# Use CollisionUtils to setup ball detection
	CollisionUtils.setup_ball_detection_area(
		wall,
		collision_shape_node,
		_on_wall_ball_entered,
		[wall]
	)

func _on_wall_ball_entered(body: Node3D, wall: StaticBody3D) -> void:
	if body is Ball:
		handle_ball_collision(body, wall)

func handle_ball_collision(ball: Ball, wall: StaticBody3D) -> void:
	# Check if collision should be processed
	if not ball.can_process_collision(wall):
		return

	# Play hit sound effect
	ball.play_hit_sound()

	# Reverse Y direction (top/bottom walls)
	ball.linear_velocity.y = - ball.linear_velocity.y

	# Set cooldown to prevent multiple rapid hits
	ball.set_collision_cooldown(wall, GameConstants.COLLISION_COOLDOWN_DURATION)
