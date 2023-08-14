class_name Collectible
extends Area2D

# Export variables
@export var value: int = 10

# Onready variables
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game: Game = $"/root/World"

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	
func _process(delta) -> void:
	pass

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		game.add_score(value)
		animatedSprite.play("collected")
		animatedSprite.animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	queue_free()
