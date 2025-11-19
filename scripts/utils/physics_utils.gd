class_name PhysicsUtils
## Utility class for creating and managing physics materials.
##
## This class provides static helper methods for creating commonly used physics materials
## to avoid code duplication across the project.

## Creates a perfectly bouncy physics material with no friction.
##
## This material is used for the ball, paddles, and arena walls to create
## the classic pong physics where objects bounce without energy loss.
##
## Returns: A PhysicsMaterial configured with bounce=1.0 and friction=0.0
static func create_bouncy_material() -> PhysicsMaterial:
	var physics_material := PhysicsMaterial.new()
	physics_material.bounce = GameConstants.PHYSICS_BOUNCE
	physics_material.friction = GameConstants.PHYSICS_FRICTION
	return physics_material
