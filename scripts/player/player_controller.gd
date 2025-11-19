extends Node3D
class_name Player
## Component-based player controller coordinating movement, effects, and collision.

@export var move_up_key: Key = KEY_UP
@export var move_down_key: Key = KEY_DOWN
@export var speed: float = 1.0
@export var speed_multiplier: float = GameConstants.PADDLE_SPEED_MULTIPLIER

var movement_component: PlayerMovement
var effects_component: PlayerEffects
var collision_component: PlayerCollision
var arena: Arena

func _ready() -> void:
	_setup_arena_reference()
	_setup_components()
	_setup_collision_body()

func _process(delta: float) -> void:
	if not movement_component:
		return

	var movement_state: Dictionary = movement_component.process_movement(delta)

	if effects_component:
		effects_component.update_effects(movement_state)

func _setup_arena_reference() -> void:
	arena = get_node_or_null("../Arena") as Arena
	if not arena:
		arena = get_tree().get_first_node_in_group("arena") as Arena

	if not arena:
		push_warning("Player: Arena not found")

func _setup_components() -> void:
	movement_component = PlayerMovement.new()
	add_child(movement_component)
	movement_component.initialize(self, move_up_key, move_down_key, speed)

	if arena:
		movement_component.setup_movement_bounds(arena)
	else:
		push_error("Player: Cannot setup movement bounds without arena")

	effects_component = PlayerEffects.new()
	add_child(effects_component)
	effects_component.initialize(self)

	collision_component = PlayerCollision.new()
	add_child(collision_component)
	collision_component.initialize(self, speed_multiplier)

func _setup_collision_body() -> void:
	var collision_body := get_node_or_null("CollisionBody") as StaticBody3D
	if not collision_body:
		push_error("Player: CollisionBody not found")
		return

	collision_body.physics_material_override = PhysicsUtils.create_bouncy_material()

	if collision_component:
		collision_component.setup_collision_detection(collision_body)
