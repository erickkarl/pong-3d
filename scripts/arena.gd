extends Node3D

class_name Arena

@export var arena_width = 80.0
@export var arena_height = 50.0
@export var wall_thickness = 2.0

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
	var wall = StaticBody3D.new()
	wall.position = pos
	wall.name = "ArenaWalls"

	# Create physics material for perfect bounce
	var physics_material = PhysicsMaterial.new()
	physics_material.bounce = 1.0 # Perfect bounce
	physics_material.friction = 0.0 # No friction
	wall.physics_material_override = physics_material

	var collision_shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size = size

	collision_shape.shape = box_shape
	wall.add_child(collision_shape)

	# Optional: Add visual mesh for debugging
	var mesh_instance = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = size
	mesh_instance.mesh = box_mesh

	# Make walls slightly transparent
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.2, 0.2, 0.8, 0.3)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_instance.material_override = material

	wall.add_child(mesh_instance)
	
	# Set up Area3D to detect ball collisions
	setup_wall_collision_detection(wall, collision_shape)

	add_child(wall)

func setup_wall_collision_detection(wall: StaticBody3D, collision_shape_node: CollisionShape3D) -> void:
	# Create Area3D to detect when ball enters
	var area = Area3D.new()
	area.name = "BallDetectionArea"
	wall.add_child(area)
	
	# Copy the collision shape
	var shape = collision_shape_node.shape
	if shape:
		var area_shape = CollisionShape3D.new()
		area_shape.shape = shape
		area.add_child(area_shape)
	
	# Connect to detect ball
	area.body_entered.connect(_on_wall_ball_entered.bind(wall))
	
	# Set collision layer/mask to detect ball
	area.collision_layer = 0
	area.collision_mask = 2  # Layer 2 is the ball

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
	ball.set_collision_cooldown(wall, 0.1)  # 100ms cooldown for walls
