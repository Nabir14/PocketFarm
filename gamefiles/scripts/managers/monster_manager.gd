extends Node
class_name MonsterManager

@export var monster : TopdownNpc2D
@export var animated_sprite : AnimatedSprite2D
@export var wander_timer : Timer

func _ready() -> void:
	monster.target_set.connect(_on_target_set)
	monster.target_reached.connect(_on_target_reached)
	wander_timer.timeout.connect(_on_wander)

func _on_target_set() -> void:
	animated_sprite.play("walk")

func _on_target_reached() -> void:
	animated_sprite.stop()

func _on_wander() -> void:
	monster.set_target(
		Vector2(
			randi_range(-monster.limit, monster.limit), 
			randi_range(-monster.limit, monster.limit)
		)
	)
