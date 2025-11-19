extends Node3D
## Main player controller that orchestrates player components.
##
## This controller manages the player paddle by coordinating movement,
## effects, and collision handling through separate component systems.

class_name Player

# ============================================================================
# EXPORTS - Configuration
# ============================================================================

@export var move_up_key: Key = KEY_UP
@export var move_down_key: Key = KEY_DOWN
@export var speed: float = 1.0
@export var speed_multiplier: float = GameConstants.PADDLE_SPEED_MULTIPLIER

# ============================================================================
# COMPONENTS
# ============================================================================

var movement_component: PlayerMovement
var effects_component: PlayerEffects
var collision_component: PlayerCollision

# ============================================================================
# REFERENCES
# ============================================================================

var arena: Arena

# ============================================================================
# LIFECYCLE METHODS
# ============================================================================

func _ready() -> void:
	_setup_arena_reference()
	_setup_components()
	_setup_collision_body()

func _process(delta: float) -> void:
	if not movement_component:
		return

	# Process movement and get movement state
	var movement_state: Dictionary = movement_component.process_movement(delta)

	# Update effects based on movement
	if effects_component:
		effects_component.update_effects(movement_state)

# ============================================================================
# SETUP METHODS
# ============================================================================

## Finds and stores a reference to the arena.
func _setup_arena_reference() -> void:
	arena = get_node_or_null("../Arena") as Arena
	if not arena:
		arena = get_tree().get_first_node_in_group("arena") as Arena

	if not arena:
		push_warning("Player: Arena not found")

## Initializes all player components.
func _setup_components() -> void:
	# Create and initialize movement component
	movement_component = PlayerMovement.new()
	add_child(movement_component)
	movement_component.initialize(self, move_up_key, move_down_key, speed)
	
	if arena:
		movement_component.setup_movement_bounds(arena)
	else:
		push_error("Player: Cannot setup movement bounds without arena")

	# Create and initialize effects component
	effects_component = PlayerEffects.new()
	add_child(effects_component)
	effects_component.initialize(self)

	# Create and initialize collision component
	collision_component = PlayerCollision.new()
	add_child(collision_component)
	collision_component.initialize(self, speed_multiplier)

## Sets up the collision body with physics material and collision detection.
func _setup_collision_body() -> void:
	var collision_body := get_node_or_null("CollisionBody") as StaticBody3D
	if not collision_body:
		push_error("Player: CollisionBody not found")
		return

	# Set up physics material using PhysicsUtils
	collision_body.physics_material_override = PhysicsUtils.create_bouncy_material()

	# Set up collision detection using the collision component
	if collision_component:
		collision_component.setup_collision_detection(collision_body)
