extends Node3D

class_name Arena

@export var arena_width = 80.0
@export var arena_height = 32.0
@export var wall_thickness = 2.0

func _ready() -> void:
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
	physics_material.bounce = 1.0  # Perfect bounce
	physics_material.friction = 0.0  # No friction
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

	add_child(wall)
