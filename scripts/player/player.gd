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

var top_exhaust: GPUParticles3D
var bottom_exhaust: GPUParticles3D

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


func _process(_delta: float) -> void:
	var new_position = position

	if(Input.is_key_pressed(move_up_key)):
		new_position.y += speed
		bottom_exhaust.visible = true
	else:
		bottom_exhaust.visible = false

	if(Input.is_key_pressed(move_down_key)):
		new_position.y -= speed
		top_exhaust.visible = true
	else:
		top_exhaust.visible = false

	# Clamp position to boundaries
	new_position.y = clamp(new_position.y, min_y_position, max_y_position)
	position = new_position
	
	
	