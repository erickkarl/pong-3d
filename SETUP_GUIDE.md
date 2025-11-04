# Godot Scene Setup Guide

All the scripts have been created! Now you need to set up the scene in the Godot Editor.

## ⚠️ CRITICAL SETTINGS - READ FIRST

Before following the setup steps, understand these critical requirements:

### 1. **Linear Damp MUST Be Zero**
- Ball will slow down over time if Linear Damp > 0
- Set in Inspector AND verify mode is "Replace" not "Combine"
- Scripts set it to 0, but Inspector can override

### 2. **Physics Material is Essential**
- Without it, ball loses energy on each collision
- Must have `bounce = 1.0` and `friction = 0.0`
- Apply to: Ball, Walls, and Paddle collision bodies

### 3. **Contact Monitor Required**
- RigidBody3D won't emit `body_entered` signals without it
- Must enable Contact Monitor AND set Max Contacts Reported > 0

### 4. **Axis Locking**
- Ball needs X and Y unlocked for 2D movement
- Z must be locked to keep it in the play plane
- Inspector settings can override script values

### 5. **Nested Collision Detection**
- Ball hits the CollisionBody child, not Player parent
- Scripts check `body.get_parent() is Player`
- Scene structure matters!

---

## Setup Steps

Follow these steps to configure the scene:

## Step 1: Update the Ball

1. Open `scenes/game.tscn` in Godot
2. Select the `ballPrl` node
3. **Change its type**: Right-click → Change Type → `RigidBody3D`
4. In the Inspector, set these properties:
   - Mass: `1.0`
   - Gravity Scale: `0.0`
   - Linear Damp: `0.0`
   - Angular Damp: `0.0`
   - Continuous CD: `true`
   - **Contact Monitor: `true`** ← CRITICAL! Required for collision signals
   - **Max Contacts Reported: `4`**
   - **Axis Lock Linear** ← Expand this section:
     - Lock Linear X: `false` (unchecked)
     - Lock Linear Y: `false` (unchecked)
     - Lock Linear Z: `true` (checked) - keeps ball in 2D plane
5. Attach the script: Click the script icon → Load → `res://scripts/ball.gd`
   - The script will automatically connect the collision signal
6. Add a `CollisionShape3D` as a child of ballPrl:
   - Right-click ballPrl → Add Child Node → `CollisionShape3D`
   - In Inspector, Shape → New `SphereShape3D`
   - Set Radius to match your ball size (approximately `1.5`)

## Step 2: Update Player 1

1. Select the `player1` node
2. Add a `StaticBody3D` as a child:
   - Right-click player1 → Add Child Node → `StaticBody3D`
   - Name it `CollisionBody`
3. Add a `CollisionShape3D` as a child of CollisionBody:
   - Right-click CollisionBody → Add Child Node → `CollisionShape3D`
   - In Inspector, Shape → New `BoxShape3D`
   - Adjust size to match your paddle model (approximately `Vector3(2, 17, 2)`)
4. The existing player1.gd script is already attached

## Step 3: Update Player 2

1. Select the `player2` node
2. Add a `StaticBody3D` as a child:
   - Right-click player2 → Add Child Node → `StaticBody3D`
   - Name it `CollisionBody`
3. Add a `CollisionShape3D` as a child of CollisionBody:
   - Right-click CollisionBody → Add Child Node → `CollisionShape3D`
   - In Inspector, Shape → New `BoxShape3D`
   - Adjust size to match your paddle model (approximately `Vector3(2, 17, 2)`)

## Step 4: Add Arena Walls

1. Add a new `Node3D` as a child of Game:
   - Right-click Game → Add Child Node → `Node3D`
   - Name it `Arena`
2. Attach the arena script:
   - Click the script icon → Load → `res://scripts/arena.gd`
3. The walls will be created automatically when you run the game

## Step 5: Add Score Zones

### Left Score Zone (Player 2 scores)
1. Add a new `Area3D` as a child of Game:
   - Right-click Game → Add Child Node → `Area3D`
   - Name it `ScoreZoneLeft`
2. Set position: `x: -45, y: 0, z: 0` (behind player 1)
3. Attach script: `res://scripts/score_zone.gd`
4. In Inspector, set `player_number` to `2`
5. Add to group "score_zones": Node tab → Groups → Add new group → "score_zones"
6. Add `CollisionShape3D` child:
   - Shape → New `BoxShape3D`
   - Size: `Vector3(2, 35, 5)`

### Right Score Zone (Player 1 scores)
1. Add another `Area3D` as a child of Game:
   - Name it `ScoreZoneRight`
2. Set position: `x: 45, y: 0, z: 0` (behind player 2)
3. Attach script: `res://scripts/score_zone.gd`
4. In Inspector, set `player_number` to `1`
5. Add to group "score_zones"
6. Add `CollisionShape3D` child:
   - Shape → New `BoxShape3D`
   - Size: `Vector3(2, 35, 5)`

## Step 6: Add Game Manager

1. Add a new `Node` as a child of Game:
   - Right-click Game → Add Child Node → `Node`
   - Name it `GameManager`
2. Attach the script:
   - Click the script icon → Load → `res://scripts/game_manager.gd`
3. In Inspector, set `win_score` to `5` (or your preferred number)

## Step 7: Create the HUD

1. Add a `CanvasLayer` as a child of Game:
   - Right-click Game → Add Child Node → `CanvasLayer`
   - Name it `HUD`
2. Attach the script: `res://scripts/ui/game_hud.gd`
3. Add Player 1 Score Label:
   - Add `Label` as direct child of HUD
   - Name it `Player1Score`
   - In Inspector → Layout → Anchor Preset: "Center Top"
   - Position: `x: -200, y: 50`
   - Text: `0`
   - Theme Overrides → Font Sizes → Font Size: `48`
   - Horizontal Alignment: Center
4. Add Player 2 Score Label:
   - Add `Label` as direct child of HUD
   - Name it `Player2Score`
   - Anchor Preset: "Center Top"
   - Position: `x: 200, y: 50`
   - Text: `0`
   - Theme Overrides → Font Sizes → Font Size: `48`
   - Horizontal Alignment: Center

## Step 8: Create Game Over Panel

1. Add `Panel` as direct child of HUD:
   - Name it `GameOverPanel`
   - In Inspector → Layout → Anchor Preset: "Center"
   - Set Custom Minimum Size: `400x200`
   - Initially set Visible to `false` (uncheck the eye icon or in Inspector)
2. Add `VBoxContainer` as child of GameOverPanel:
   - Set Layout to "Full Rect"
   - Theme Overrides → Constants → Separation: `10`
3. Add `Label` as child of VBoxContainer:
   - Name it `WinnerLabel`
   - Text: `Player X Wins!`
   - Theme Overrides → Font Sizes → Font Size: `32`
   - Horizontal Alignment: Center
4. Add `Button` as child of VBoxContainer:
   - Name it `RestartButton`
   - Text: `Restart`
   - In Node tab → Signals → double-click `pressed` signal
   - Connect to HUD node → Select `_on_restart_button_pressed`
5. Add `Button` as child of VBoxContainer:
   - Name it `MainMenuButton`
   - Text: `Main Menu`
   - Connect `pressed` signal to HUD's `_on_main_menu_button_pressed`

## Step 9: Configure Collision Layers (Important!)

This ensures the ball only collides with the right objects:

### Set up layers:
1. Go to Project → Project Settings → Layer Names → 3D Physics
2. Name the layers:
   - Layer 1: "Players"
   - Layer 2: "Ball"
   - Layer 3: "Walls"
   - Layer 4: "ScoreZones"

### Apply to nodes:

**Ball (RigidBody3D):**
- Collision Layer: Layer 2 (Ball)
- Collision Mask: Layer 1 (Players) + Layer 3 (Walls)

**Player CollisionBody (StaticBody3D):**
- Collision Layer: Layer 1 (Players)
- Collision Mask: Layer 2 (Ball)

**Arena Walls (created programmatically):**
- Will be set to Layer 3 automatically

**Score Zones (Area3D):**
- Collision Layer: Layer 4 (ScoreZones)
- Collision Mask: Layer 2 (Ball)

## Step 10: Test the Game!

1. Save the scene (Ctrl+S)
2. Run the project (F5)
3. Test that:
   - Players move up/down with W/S and Arrow keys
   - Ball bounces off paddles and walls
   - Score increases when ball goes past a paddle
   - Game ends at 5 points
   - Restart and Main Menu buttons work

## Common Issues and Fixes

### Ball doesn't move or only moves up/down
- **Check Axis Lock settings** - Make sure Lock Linear X is UNCHECKED
- Verify Lock Linear Y is UNCHECKED
- The script unlocks these automatically, but inspector settings may override
- Check that the ball's `_ready()` function is being called
- Verify gravity_scale is 0
- Check launch_ball() debug output shows X velocity is not zero

### Ball passes through paddles
- **MOST COMMON:** Ensure Contact Monitor is enabled and Max Contacts Reported > 0
- Ensure Continuous CD is enabled on the ball
- Check collision layers and masks are set correctly
- Verify collision shapes are properly sized
- Make sure StaticBody3D is added to players

### Collisions not detected / _on_body_entered not triggering
- **Check Contact Monitor is enabled** (most common issue!)
- **Set Max Contacts Reported to at least 4**
- Verify the `body_entered` signal is connected (the script does this automatically)
- Check collision layers/masks match between ball and paddles
- Make sure collision shapes exist and are children of the physics bodies

### Scores don't update
- Verify score zones are in the "score_zones" group
- Check that signals are connected properly
- Make sure GameManager can find the ball node

### No exhaust effects
- The player scripts already handle this
- Check that the particle effects are in the correct path

### HUD doesn't show
- Verify CanvasLayer is a child of Game
- Check that node names match exactly (Player1Score, Player2Score)
- Ensure the script is attached to the HUD CanvasLayer

## Final Scene Structure

Your scene should look like this:

```
Game (Node3D)
├── WorldEnvironment
├── Camera3D
├── player1 (with player1.gd)
│   ├── [existing mesh]
│   └── CollisionBody (StaticBody3D)
│       └── CollisionShape3D
├── player2 (with player2.gd)
│   ├── [existing mesh]
│   └── CollisionBody (StaticBody3D)
│       └── CollisionShape3D
├── Ball (RigidBody3D with ball.gd)
│   ├── ballPrl [existing mesh moved here as child]
│   └── CollisionShape3D (SphereShape3D)
├── Arena (Node3D with arena.gd)
├── ScoreZoneLeft (Area3D with score_zone.gd)
│   └── CollisionShape3D (BoxShape3D)
├── ScoreZoneRight (Area3D with score_zone.gd)
│   └── CollisionShape3D (BoxShape3D)
├── GameManager (Node with game_manager.gd)
├── OmniLight3D
└── HUD (CanvasLayer with game_hud.gd)
    ├── Player1Score (Label)
    ├── Player2Score (Label)
    └── GameOverPanel (Panel - initially hidden)
        └── VBoxContainer
            ├── WinnerLabel (Label)
            ├── RestartButton (Button)
            └── MainMenuButton (Button)
```

## Final Checklist

Before running the game, verify these critical settings:

- [ ] Ball Linear Damp = 0 (mode: "Replace")
- [ ] Ball Contact Monitor = true
- [ ] Ball Max Contacts Reported = 4
- [ ] Ball Axis Lock: X=false, Y=false, Z=true
- [ ] Ball has Physics Material (bounce=1, friction=0)
- [ ] Players have CollisionBody (StaticBody3D) children
- [ ] Players have Physics Material (bounce=1, friction=0)
- [ ] Arena script attached and walls visible
- [ ] Score Zones in "score_zones" group
- [ ] GameManager attached to GameManager node
- [ ] HUD script attached to CanvasLayer
- [ ] Button signals connected

## Testing the Game

1. **Press F5** to run
2. **Ball should launch** after 1 second with horizontal movement
3. **Ball should bounce** off walls and paddles without losing speed
4. **Speed should increase** by 10% each paddle hit
5. **Scores should update** when ball passes paddles
6. **Game over at 5 points** with winner displayed
7. **Restart button** resets the game
8. **Main Menu button** returns to menu

## Troubleshooting Quick Reference

| Problem | Solution |
|---------|----------|
| Ball slows down | Check Linear Damp = 0 |
| Ball only moves up/down | Unlock X axis |
| No collisions | Enable Contact Monitor |
| Ball passes through paddle | Add CollisionBody + Physics Material |
| Multiple bounces | Already fixed (cooldown in script) |
| Speed not increasing | Already fixed (multiplies whole vector) |

## Next Steps for Polish

See `context.md` "Future Enhancements" section for ideas:
- Audio (sounds & music)
- Visual effects (trails, impacts, screen shake)
- Game modes (AI, difficulty, time attack)
- Settings menu (volume, controls, difficulty)
- Stats tracking (high scores, longest rally)

## Success!

If you've followed all the steps and the checklist passes, you now have a fully functional 3D Pong game!

**Enjoy playing and customizing your game!** 🎮

For implementation details and troubleshooting, refer to `context.md`.
