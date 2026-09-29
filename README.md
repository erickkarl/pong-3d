# Pong 3D

A local two-player pong game in 3D, built with Godot 4.5. Paddles fire thruster flames as they move, the ball speeds up with every hit, and goals drain a health bar instead of adding to a score.

## Features

- **Two players on one keyboard** with frame-rate-independent, arena-clamped paddle movement.
- **Angle control:** the ball leaves a paddle at an angle set by where it hit. Hits farther from the paddle's center send it steeper.
- **Escalating speed:** each paddle hit multiplies the ball's speed by 1.1, from a launch speed of 40 up to a cap of 175. Speed resets after every goal.
- **Health instead of points:** both players start at 100 HP and every goal costs 20 HP, so a match ends after five goals. Health bars turn green, yellow, then red as HP drops, and a game-over panel offers Restart and Main Menu.
- **Feedback:** GPU-particle exhaust flames and a looping thruster sound while a paddle moves, plus positional (3D) audio on ball hits.
- **Scene setup:** panorama sky with glow, a rotating planet on the main menu, and top and bottom arena walls generated in code.

## Controls

| Action | Player 1 | Player 2 |
| --- | --- | --- |
| Move up | `W` | `Up arrow` |
| Move down | `S` | `Down arrow` |

Keys are set per player in `scripts/player/player1.gd` and `player2.gd`. The project does not use the Godot InputMap.

## Getting started

**Requirements:** [Godot 4.5](https://godotengine.org/download) (the project targets 4.5 with the Forward+ renderer).

```bash
git clone https://github.com/erickkarl/pong-3d.git
```

1. Open Godot, choose **Import**, and select `project.godot`.
2. Press **F5**. The main scene is `scenes/main_menu.tscn`.

From the command line, `godot --path .` runs the project.

**Exporting:** `export_presets.cfg` is git-ignored, so create your own preset under **Project > Export** (Godot 4.5 export templates required). Headless export then looks like:

```bash
godot --headless --export-release "<your preset name>" build/pong3d
```

## How it works

### Component-based paddles

`Player` (`scripts/player/player_controller.gd`) creates and wires three focused components at runtime. `player1.gd` and `player2.gd` only assign the input keys.

```
Player
├── PlayerMovement   keyboard input and arena bounds
├── PlayerEffects    exhaust particles and thruster audio
└── PlayerCollision  ball deflection angle and speed-up
```

### Scripted ball

`Ball` is a `CharacterBody3D` moved with `move_and_collide`. It reflects off the walls with `velocity.bounce()`. Paddle hits are handled by `PlayerCollision`, which computes the outgoing direction from the hit position. A short collision cooldown (0.1 s) prevents double hits. The ball is locked to the XY plane, so the game plays as 2D inside a 3D scene.

### Signals and groups

Scoring is decoupled through signals:

```
ScoreZone.ball_entered_zone ──> GameManager ──> health_changed ──> GameHUD
                                            └─> game_over ───────> GameHUD
```

`Arena` registers itself in the `arena` group and paddles look it up with `get_first_node_in_group("arena")` to compute their movement bounds. `SceneManager` (autoload) handles scene changes and logs failures with `push_error`.

### Shared configuration

Tunable values (speeds, health, thresholds, colors, delays) live in one place: `scripts/constants/game_constants.gd` (`GameConstants`). `PhysicsUtils` and `CollisionUtils` are static helper classes in `scripts/utils/`.

## Project structure

```
pong-3d/
├── addons/godot-git-plugin/   Editor-only Git integration (third-party, see Credits)
├── assets/
│   ├── fx/                    Exhaust flame particle scenes and mesh
│   ├── models/                Paddle, ball and planet models
│   ├── sfx/                   Ball hit and thruster sounds
│   ├── skybox/                Panorama sky
│   ├── textures/              Flame texture
│   └── ui/                    Menu button art
├── scenes/                    main_menu.tscn, game.tscn
├── scripts/
│   ├── autoload/              SceneManager
│   ├── constants/             GameConstants
│   ├── player/                Player controller and its components
│   ├── ui/                    Main menu and HUD
│   ├── utils/                 PhysicsUtils, CollisionUtils
│   ├── arena.gd, ball.gd, game_manager.gd, score_zone.gd, planet.gd
└── project.godot
```

## Tech

- Godot 4.5, Forward+ renderer
- GDScript with static typing
- Godot 3D physics (`CharacterBody3D`, `StaticBody3D`, `Area3D`), named physics layers for Players, Ball, Walls and ScoreZones
- `GPUParticles3D`, `AudioStreamPlayer3D`, `WorldEnvironment` with panorama sky and glow

## Status and roadmap

The core game loop is implemented: menu, match, health bars, game over. The project is a work in progress and has no automated tests yet.

**Known issues**

- The **Settings** button on the main menu is a placeholder. Its signal points to a handler that does not exist.
- The game-over **Restart** button has no label.
- The ball can flicker, and the collision cooldown is a workaround that needs a proper fix.
- Main menu labels are in Portuguese; in-game UI text is in English.

**Planned**

- [ ] Spawn power-ups
- [ ] Heal power-up
- [ ] Duplicate-ball power-up
- [ ] Pause menu (settings, return to main menu, resolution, volume)
- [ ] Polished game-over and play-again screen
- [ ] Replace the collision cooldown

## Credits

- **[Godot Engine](https://godotengine.org)**, MIT license.
- **[Godot Git Plugin](https://github.com/godotengine/godot-git-plugin)** v3.1.1 by twaritwaikar and the Godot Engine community, MIT license. Bundled in `addons/godot-git-plugin/` as an editor-only tool; the game does not use it. Its own third-party components (godot-cpp, libgit2, libssh2, OpenSSL) and their licenses are listed in `addons/godot-git-plugin/THIRDPARTY.md`.
- **Planet texture** (`assets/models/planets/GG-0001-N.png`): pixel planet by **AstroJar** ([x.com/AstroJar_](https://x.com/AstroJar_), [patreon.com/AstroJar](https://www.patreon.com/AstroJar)); the artist's credit is embedded in the texture file. Check the license of the original pack before redistributing it.
- **Menu button graphic** (`assets/ui/buttons/button_default.png`): AI-generated with ChatGPT (GPT-4o), according to the content credentials embedded in the file.
- **3D models** in `assets/models/` and `assets/fx/` were exported from Blender.
- The source and license of the panorama sky, the two sound effects and the exhaust flame texture are not recorded in this repository.

Built by Erick Karl, Lucas Borges and decarc (see the commit history).
