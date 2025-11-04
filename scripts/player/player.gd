extends Node3D

class_name Player

@export
var move_down_key = KEY_DOWN

@export
var move_up_key = KEY_UP

@export
var speed = 1

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if(Input.is_key_pressed(move_up_key)):
		translate(Vector3(0,1*speed,0))
		
	if(Input.is_key_pressed(move_down_key)):
		translate(Vector3(0,-1*speed,0))
	
	