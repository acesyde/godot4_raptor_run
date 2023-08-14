class_name Game
extends Node2D

# Export variables
@export var world_speed : int = 300
@export var collectible_pitch_reset_interval : int = 1000

# Onready variables
@onready var moving_environment: Node2D = $Environment/Moving
@onready var collect_sound: AudioStreamPlayer = $Sounds/CollectSound
@onready var score_label: Label = $HUD/UI/Score


# Private variables
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var last_platform_position: Vector2 = Vector2.ZERO
var next_spawn_time: int = 0
var score: int = 0
var collectible_pitch: float = 1.0
var reset_collectible_pitch_time: int = 0

# Constants
const available_platforms = [
		preload("res://scenes/platform.tscn"),
		preload("res://scenes/platform_collectible_single.tscn"),
		preload("res://scenes/platform_collectible_row.tscn"),
		preload("res://scenes/platform_collectible_rainbow.tscn"),
]

func _ready() -> void:
	rng.randomize()
	
func _process(delta) -> void:
	# Reset the collectible sound pitch after a time
	if Time.get_ticks_msec() > reset_collectible_pitch_time:
		collectible_pitch = 1.0
	
	# Spawn a new platform
	if Time.get_ticks_msec() > next_spawn_time:
		_spawn_next_platform()
		
	# Update the UI labels
	score_label.set_text("Score: %s" % score)
	

func _spawn_next_platform() -> void:
	var random_platform_scene = available_platforms.pick_random()
	var new_platform: Platform = random_platform_scene.instantiate()
	
	# Set the position of the new position
	if last_platform_position == Vector2.ZERO:
		new_platform.position = Vector2(400,0)
	else:
		var x = last_platform_position.x + rng.randi_range(450,550)
		var y = clamp(last_platform_position.y + rng.randi_range(-150,150), 200, 1000)
		new_platform.position = Vector2(x,y)
		
	# Add the platform to the moving environment
	moving_environment.add_child(new_platform)
	
	# Update the last platform position and increase the next spawn
	last_platform_position = new_platform.position
	next_spawn_time  += world_speed
	

func _physics_process(delta) -> void:
	# Move the platforms left
	moving_environment.position.x -= world_speed * delta

func add_score(value):
	score += value
	collect_sound.set_pitch_scale(collectible_pitch)
	collect_sound.play()
	collectible_pitch += 0.1
	reset_collectible_pitch_time = Time.get_ticks_msec() * collectible_pitch_reset_interval
