# Pong 3D

A 3D pong game built with Godot 4, featuring component-based architecture and physics-driven gameplay.

## Quick Start

1. Open project in Godot 4
2. Run `scenes/main_menu.tscn`

## Project Structure

```
pong-3d/
├── assets/              # Game assets (fx, models, sfx, textures, ui)
├── scenes/              # Scene files (game, main_menu)
└── scripts/             # All code
    ├── autoload/        # Singletons (SceneManager)
    ├── constants/       # Global constants
    ├── player/          # Player components
    ├── ui/              # UI controllers
    └── utils/           # Utility classes
```

## Architecture

### Component-Based Design

Entities split into focused components for separation of concerns:

```gdscript
Player (Controller)
├── PlayerMovement (input & boundaries)
├── PlayerEffects (particles & audio)
└── PlayerCollision (ball collision)
```

**Files:** `scripts/player/player_*.gd`

### Static Utilities

Shared functionality in static classes:

```gdscript
class_name PhysicsUtils
static func create_bouncy_material() -> PhysicsMaterial
```

**Files:** `scripts/utils/*_utils.gd`

### Centralized Constants

Single source of truth for configuration:

```gdscript
class_name GameConstants
const PADDLE_SPEED_MULTIPLIER: float = 1.1
const PHYSICS_BOUNCE: float = 1.0
```

**File:** `scripts/constants/game_constants.gd`

### Signal-Based Events

Loose coupling via observer pattern:

```gdscript
# Publisher
signal ball_scored(player_num: int)

# Subscriber
manager.ball_scored.connect(_on_ball_scored)
```

### Group-Based Discovery

Find nodes dynamically:

```gdscript
add_to_group("arena")  # Register
arena = get_tree().get_first_node_in_group("arena")  # Discover
```

## Adding Features

### 1. Add Constants

```gdscript
# scripts/constants/game_constants.gd
const FEATURE_SPEED: float = 100.0
```

### 2. Create Utilities (if shared)

```gdscript
# scripts/utils/feature_utils.gd
class_name FeatureUtils
static func setup_feature() -> void
```

### 3. Implement Components

```gdscript
# scripts/entity/entity_component.gd
class_name EntityComponent
extends Node

var entity: Node3D

func initialize(p_entity: Node3D) -> void:
    entity = p_entity

func process_component(delta: float) -> Dictionary:
    return {}
```

### 4. Add Assets

Place in appropriate `assets/` subdirectory:
- `assets/fx/` - Particle effects (.tscn)
- `assets/models/` - 3D models (.glb)
- `assets/sfx/` - Sound effects (.mp3)
- `assets/textures/` - Materials (.png)

### 5. Integrate

Connect signals, add to groups, update UI.

## Code Standards

**Type Safety:**
```gdscript
var player: Player
var speed: float = 100.0
func calculate(base: float) -> float
```

**Class Names:**
```gdscript
class_name PowerUpManager
extends Node
```

**Initialization Pattern:**
```gdscript
func _ready() -> void:
    _setup_references()
    _setup_components()
    _setup_physics()
    _setup_signals()
    _setup_visuals()
```

**File Structure:**
1. `class_name` and `extends`
2. Documentation
3. Signals
4. Constants
5. Preloads
6. @export variables
7. Public variables
8. Private variables (prefix `_`)
9. Lifecycle methods
10. Public methods
11. Private methods

## Physics

**Perfect Bounce:**
```gdscript
gravity_scale = 0.0
linear_damp = 0.0
angular_damp = 0.0
physics_material_override = PhysicsUtils.create_bouncy_material()
```

**Collision Detection:**
```gdscript
CollisionUtils.setup_ball_detection_area(parent, shape, callback)
```

**Collision Cooldown:**
```gdscript
if ball.can_process_collision(self):
    # Handle collision
    ball.set_collision_cooldown(self, duration)
```

## Visual Effects

**Particle Setup:**
```gdscript
const FX := preload("res://assets/fx/effect.tscn")
var particle = FX.instantiate()
parent.add_child(particle)
particle.emitting = true
particle.visible = false  # Toggle visibility, not emitting
```

**Why visibility over emitting:** No startup delay, instant feedback.

## Key Files

- `scripts/player/player_controller.gd` - Player controller
- `scripts/ball.gd` - Ball physics and collision
- `scripts/arena.gd` - Arena generation
- `scripts/game_manager.gd` - Game state management
- `scripts/constants/game_constants.gd` - All constants
- `scripts/utils/physics_utils.gd` - Physics helpers
- `scripts/utils/collision_utils.gd` - Collision helpers

## Controls

**Player 1:** W/S
**Player 2:** Up/Down arrows

## Todo

- [ ] Spawn power-ups mechanic
- [ ] Heal (power-up)
- [ ] Duplicate balls (power-up)
- [ ] Fix bug ball flickering
- [ ] Refactor need of collision cooldown
- [ ] Create pause menu (config, return to main screen, resolution and volume)
- [ ] Create play again screen
