class_name CollisionUtils
## Utility class for setting up collision detection areas.
##
## This class provides static helper methods for creating Area3D nodes to detect
## ball collisions, reducing code duplication between arena walls and player paddles.

## Sets up an Area3D collision detection zone on a StaticBody3D.
##
## Creates an Area3D node with the same collision shape as the parent body,
## configured to detect objects on collision layer 2 (the ball).
##
## @param parent: The StaticBody3D node to attach the detection area to
## @param collision_shape: The CollisionShape3D to copy for the detection area
## @param callback: The callable to connect to the body_entered signal
## @param bind_args: Optional array of arguments to bind to the callback
static func setup_ball_detection_area(
	parent: StaticBody3D,
	collision_shape: CollisionShape3D,
	callback: Callable,
	bind_args: Array = []
) -> Area3D:
	# Create Area3D to detect when ball enters
	var area := Area3D.new()
	area.name = "BallDetectionArea"
	parent.add_child(area)

	# Copy the collision shape
	if collision_shape and collision_shape.shape:
		var area_shape := CollisionShape3D.new()
		area_shape.shape = collision_shape.shape
		area.add_child(area_shape)

	# Connect to detect ball with optional bound arguments
	if bind_args.is_empty():
		area.body_entered.connect(callback)
	else:
		area.body_entered.connect(callback.bindv(bind_args))

	# Set collision layer/mask to detect ball
	area.collision_layer = 0
	area.collision_mask = GameConstants.BALL_COLLISION_MASK

	return area
