class_name Player
extends CharacterBody2D

# Exported values
@export var gravity : int = 1600
@export var jump_power : int = 600

# OnReady values
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer = $JumpSound

# Private values
var active: bool = true
var jumps_remaining: int = 2
var was_jumping: bool = false
var jump_pitch: float = 1.0

func _ready():
	print("hello world")

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if active:
		# Reset the player after landing
		if was_jumping and is_on_floor():
			was_jumping = false
			jumps_remaining = 2
			animatedSprite.play("run")
			jump_pitch = 1.0
			
		# Handle jumping
		if Input.is_action_just_pressed("jump") and jumps_remaining > 0:
			jumps_remaining -= 1
			was_jumping = true
			velocity.y = -jump_power
			
			if jumps_remaining == 1:
				animatedSprite.play("jump")
			else:
				
				animatedSprite.play("double_jump")
				
			jump_sound.set_pitch_scale(jump_pitch)
			jump_sound.play()
			jump_pitch += 0.2
	
	move_and_slide()
