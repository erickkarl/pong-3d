class_name GameConstants
## Centralized configuration for all game values.

const PADDLE_HALF_HEIGHT: float = 8.5
const PADDLE_EXHAUST_OFFSET: float = 8.450854
const PADDLE_SPEED_MULTIPLIER: float = 1.1
const MAX_BALL_SPEED: float = 175.0
const PLAYER_MOVEMENT_SPEED: float = 0.5

const BALL_LAUNCH_DELAY: float = 1.0
const BALL_RESET_DELAY: float = 2.0
const BALL_ROTATION_SPEED: float = 0.1

const BALL_COLLISION_MASK: int = 2
const COLLISION_COOLDOWN_DURATION: float = 0.1

const PHYSICS_BOUNCE: float = 1.0
const PHYSICS_FRICTION: float = 0.0

const INITIAL_HEALTH: int = 100
const HEALTH_DAMAGE_PER_SCORE: int = 20
const MIN_HEALTH: int = 0

const HEALTH_THRESHOLD_HEALTHY: int = 60
const HEALTH_THRESHOLD_WARNING: int = 30
const HEALTH_COLOR_HEALTHY: Color = Color(0.2, 0.8, 0.2, 1.0)
const HEALTH_COLOR_WARNING: Color = Color(0.9, 0.7, 0.2, 1.0)
const HEALTH_COLOR_CRITICAL: Color = Color(0.9, 0.2, 0.2, 1.0)

## Target framerate for movement normalization
const TARGET_FPS: float = 60.0

## Audio volume in dB
const SFX_VOLUME_DB: float = 0.0
