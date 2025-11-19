class_name CollisionUtils
## Shared collision detection setup utilities.

## Creates Area3D on StaticBody3D to detect ball collisions.
static func setup_ball_detection_area(
	parent: StaticBody3D,
	collision_shape: CollisionShape3D,
	callback: Callable,
	bind_args: Array = []
) -> Area3D:
	var area := Area3D.new()
	area.name = "BallDetectionArea"
	parent.add_child(area)

	if collision_shape and collision_shape.shape:
		var area_shape := CollisionShape3D.new()
		area_shape.shape = collision_shape.shape
		area.add_child(area_shape)

	if bind_args.is_empty():
		area.body_entered.connect(callback)
	else:
		area.body_entered.connect(callback.bindv(bind_args))

	area.collision_layer = 0
	area.collision_mask = GameConstants.BALL_COLLISION_MASK

	return area
