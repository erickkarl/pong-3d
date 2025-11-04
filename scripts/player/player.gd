extends Node3D

class_name Player

@export
var move_down_key = KEY_DOWN

@export
var move_up_key = KEY_UP

@export
var speed = 1

const fireAnimation = preload("res://assets/fx/exhaust_flame_vfx.tscn")

var top_exhaust: GPUParticles3D
var bottom_exhaust: GPUParticles3D

func _ready() -> void:
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
	if(Input.is_key_pressed(move_up_key)):
		translate(Vector3(0,1*speed,0))
		bottom_exhaust.visible = true
	else:
		bottom_exhaust.visible = false
	if(Input.is_key_pressed(move_down_key)):
		translate(Vector3(0,-1*speed,0))
		top_exhaust.visible = true
	else:
		top_exhaust.visible = false
	
	
	