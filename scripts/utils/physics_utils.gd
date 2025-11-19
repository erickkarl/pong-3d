class_name PhysicsUtils
## Shared physics material creation.

## Creates perfect bounce material (no energy loss, no friction).
static func create_bouncy_material() -> PhysicsMaterial:
	var physics_material := PhysicsMaterial.new()
	physics_material.bounce = GameConstants.PHYSICS_BOUNCE
	physics_material.friction = GameConstants.PHYSICS_FRICTION
	return physics_material
