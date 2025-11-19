## Git Workflow
- Do not include Claude Code in commit messages
- Use conventional commits (be brief and descriptive)

# Software Engineering Concepts
- type-safety (static typing in GDScript, type inference with `:=`)
- monitoring/observability/profiling (use Godot profiler)
- simplicity (KISS, YAGNI, 1 idea per sentence, no clutter/filler words)
- descriptive naming (avoid vague terms: data, item, list, component, info)
- automated testing (use GUT or gdUnit4, prevents bug re-occurrence)
- error-handling (provide user feedback, use push_error())
- writing (1 idea per sentence, no clutter/filler, lead with result, use active voice, no emojis unless asked)
- focus on:
  - static typing with type inference
  - performance profiling
  - memory management (queue_free unused nodes, object pooling)
- comments are unnecessary 98% of the time, convert them to be a function/variable instead
- use signals for decoupled node communication
- avoid premature optimization
- every character must earn its place
- be concrete and specific: `retry_after_ms` > `timeout`, `email_validator` > `validator`
- avoid useless abstractions (functions that mainly call one function, helper used only once)
- keep code close to where it's used, unless used 2-3+ times
- a folder with a single script should be a single script

# GDScript
- use static typing: `var speed: float = 100.0` or `var player := $Player as Player`
- prefer `@export` over magic numbers
- use `@onready` for node references: `@onready var player: Player = $Player`
- snake_case for variables/functions, PascalCase for classes/files, SCREAMING_SNAKE_CASE for constants
- prefer `await` over `yield` (Godot 4.x)
- unused vars start with _ (or don't exist)
- prefer string interpolation: `"Score: %d" % score`
- don't abbreviate; use descriptive names
- always use early return over nested if-else
- prefer match over long if-elif chains
- remove redundancy: `enemies` not `enemy_list`
- avoid suffixes like Manager, Helper, Controller unless essential

# Godot Patterns
- use signals for node communication, avoid direct coupling
- prefer composition over inheritance
- use Autoloads sparingly, only for true global state
- don't call get_node() in _process(), use @onready
- use `queue_free()` not `free()`
- prefer Resources for data structures
- leverage built-in nodes before custom solutions
- don't create nodes in _process() loops; use object pooling
- use InputMap over hardcoded input checks
- keep scene tree shallow
- cache node references
- disable unused process callbacks: `set_process(false)`

# Scene Organization
- one responsibility per scene
- keep scenes small and composable
- organize by feature, not by node type
- use PackedScenes for instantiation
- separate game logic from presentation

# Testing
- use GUT or gdUnit4
- always test behavior, never test implementation
- don't use "should", use 3rd person verbs
- write a test for each bug you fix to ensure no re-occurrence
- use describe clauses: segment the test file as feature behavioral