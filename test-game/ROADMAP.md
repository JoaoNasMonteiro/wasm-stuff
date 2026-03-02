# WASM-4 Arena Shooter - Roadmap & Design Document

## 1. Overview
A wave-based arena shooter (similar to Vampire Survivors, but with manual aiming and shooting). The player faces 10 waves of enemies in an open map.
* Engine: WASM-4
* Language: Pure C
* Controls: Keyboard/Gamepad (8-way movement and shooting)
* The Golden Rule: ZERO dynamic allocation (no `malloc` or `free`). The hard limit is 64KB of total memory. Everything must be statically allocated at compile time.

---

## 2. Memory Architecture: Object Pools
Since we cannot create and destroy enemies or bullets on the fly without causing memory fragmentation, we allocate all possible entities at once in global memory using structs. To "spawn" an entity, we find an inactive one in the array and flag it as active.



```c
#include "wasm4.h"
#include <stdbool.h>

#define MAX_BULLETS 100
#define MAX_ENEMIES 50

typedef struct {
    float x, y;
    float dir_x, dir_y; // Normalized direction (-1.0 to 1.0)
    bool active;
} Entity;

// Global Object Pools
static Entity bullets[MAX_BULLETS];
static Entity enemies[MAX_ENEMIES];

// Player State
static float player_x = 80.0f;
static float player_y = 80.0f;
static float aim_dir_x = 1.0f; // The direction the player is currently facing
static float aim_dir_y = 0.0f;
```

---

## 3. 8-Way Movement and Aiming
Instead of using a mouse, the player shoots in the last direction they moved. We read the D-Pad bit by bit. If multiple directional buttons are pressed simultaneously, we handle diagonals naturally.



```c
void update_player() {
    uint8_t gamepad = *GAMEPAD1;
    float move_x = 0.0f;
    float move_y = 0.0f;

    if (gamepad & W4_BUTTON_LEFT)  move_x = -1.0f;
    if (gamepad & W4_BUTTON_RIGHT) move_x =  1.0f;
    if (gamepad & W4_BUTTON_UP)    move_y = -1.0f;
    if (gamepad & W4_BUTTON_DOWN)  move_y =  1.0f;

    // Update position
    player_x += move_x;
    player_y += move_y;

    // Save the last faced direction for shooting (only if moving)
    if (move_x != 0.0f || move_y != 0.0f) {
        aim_dir_x = move_x;
        aim_dir_y = move_y;
    }

    // Shooting logic
    if (gamepad & W4_BUTTON_1) { // Button X
        // Spawn bullet from the pool using aim_dir_x and aim_dir_y
    }
}
```

---

## 4. The Horde and Pathfinding Design Choice
Conscious design decision: The map will NOT have physical obstacles.
If obstacles were included, enemies would get stuck on them while walking in a straight line toward the player. Solving this requires Pathfinding algorithms (like A* or Flow Fields), which are too heavy for a 64KB memory limit and overcomplicate a first C project. The challenge will come purely from horde management in an open arena.

Enemies will simply calculate the vector toward the player, normalize it, and move forward.

---

## 5. Implementation Milestones

### Phase 1: Core Mechanics (Movement & Shooting)
* Set up the player state variables.
* Read `GAMEPAD1` to move and update the `aim_dir` vector.
* Implement the `bullets` object pool.
* Spawn a bullet traveling in the `aim_dir` when the action button is pressed.

### Phase 2: The Horde & Collisions
* Implement the `enemies` object pool.
* Write the math for enemies to constantly update their direction toward the player.
* Implement simple AABB (Axis-Aligned Bounding Box) collision detection for:
  * Bullets vs. Enemies (Deactivate both on hit).
  * Enemies vs. Player (Take damage/Game Over).

### Phase 3: The Wave System
* Build a simple state machine (e.g., `STATE_SPAWN`, `STATE_PLAYING`, `STATE_INTERMISSION`).
* Use the 60 FPS update loop as a timer (60 frames = 1 second) to control spawn rates and wave transitions.
* Ramp up enemy speed or spawn rate across 10 distinct waves.

### Phase 4: Polish and Game Loop
* Implement Game Over and Victory screens.
* Write a reset function to clear the object pools and restart the level.
* Add basic procedural visual elements to the floor (non-colliding grass or marks) to give a sense of movement.
* Add sound effects and tune the 4-color palette.
