extends Node3D
class_name Arena
## Programmatically generates arena walls with ball collision detection.

@export var arena_width: float = 100.0
@export var arena_height: float = 50.0
@export var wall_thickness: float = 2.0

func _ready() -> void:
	add_to_group("arena")
	create_walls()

func create_walls() -> void:
	create_wall(
		Vector3(0, arena_height / 2, 0),
		Vector3(arena_width, wall_thickness, 2)
	)

	create_wall(
		Vector3(0, -arena_height / 2, 0),
		Vector3(arena_width, wall_thickness, 2)
	)

func create_wall(pos: Vector3, size: Vector3) -> void:
	var wall := StaticBody3D.new()
	wall.position = pos
	wall.name = "ArenaWalls"
	wall.physics_material_override = PhysicsUtils.create_bouncy_material()

	var collision_shape := CollisionShape3D.new()
	var box_shape := BoxShape3D.new()
	box_shape.size = size
	collision_shape.shape = box_shape
	wall.add_child(collision_shape)

	var mesh_instance := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	box_mesh.size = size
	mesh_instance.mesh = box_mesh

	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.2, 0.2, 0.8, 0.3)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_instance.material_override = material
	wall.add_child(mesh_instance)

	add_child(wall)
