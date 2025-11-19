class_name GameConstants
## Global constants for game configuration.
##
## This class contains all magic numbers and configuration values used throughout
## the game, making them easy to find, modify, and maintain in a single location.

# ============================================================================
# PLAYER CONSTANTS
# ============================================================================

## Half-height of the paddle (17 units total height / 2 = 8.5)
const PADDLE_HALF_HEIGHT: float = 8.5

## Vertical offset for paddle exhaust particle effects
const PADDLE_EXHAUST_OFFSET: float = 8.450854

## Speed multiplier applied to ball velocity after paddle collision
const PADDLE_SPEED_MULTIPLIER: float = 1.1

## Base movement speed for player paddles
const PLAYER_MOVEMENT_SPEED: float = 0.5

# ============================================================================
# BALL CONSTANTS
# ============================================================================

## Delay in seconds before launching the ball at game start
const BALL_LAUNCH_DELAY: float = 1.0

## Delay in seconds before resetting and relaunching the ball after scoring
const BALL_RESET_DELAY: float = 2.0

## Base rotation speed for the ball's visual spin effect
const BALL_ROTATION_SPEED: float = 0.1

# ============================================================================
# COLLISION CONSTANTS
# ============================================================================

## Collision layer mask for the ball (layer 2)
const BALL_COLLISION_MASK: int = 2

## Cooldown duration in seconds to prevent multiple rapid collision detections
const COLLISION_COOLDOWN_DURATION: float = 0.1

# ============================================================================
# PHYSICS CONSTANTS
# ============================================================================

## Perfect bounce value - no energy loss on collision
const PHYSICS_BOUNCE: float = 1.0

## No friction value for frictionless surfaces
const PHYSICS_FRICTION: float = 0.0

# ============================================================================
# GAME RULES CONSTANTS
# ============================================================================

## Initial health for each player at game start
const INITIAL_HEALTH: int = 100

## Health damage dealt when opponent scores
const HEALTH_DAMAGE_PER_SCORE: int = 20

## Minimum health value (cannot go below this)
const MIN_HEALTH: int = 0

# ============================================================================
# UI CONSTANTS
# ============================================================================

## Health threshold above which health bar is green (healthy)
const HEALTH_THRESHOLD_HEALTHY: int = 60

## Health threshold above which health bar is yellow (warning)
const HEALTH_THRESHOLD_WARNING: int = 30

## Color for healthy health bar (green)
const HEALTH_COLOR_HEALTHY: Color = Color(0.2, 0.8, 0.2, 1.0)

## Color for warning health bar (yellow/orange)
const HEALTH_COLOR_WARNING: Color = Color(0.9, 0.7, 0.2, 1.0)

## Color for critical health bar (red)
const HEALTH_COLOR_CRITICAL: Color = Color(0.9, 0.2, 0.2, 1.0)
