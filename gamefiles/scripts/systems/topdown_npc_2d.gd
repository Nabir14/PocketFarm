extends CharacterBody2D
class_name TopdownNpc2D

signal target_set
signal target_reached

@export var limit : int = 32
@export var speed : float = 20.

var disabled : bool = false
var target_position : Vector2
var should_follow : bool = false

func set_target(target_pos : Vector2) -> void:
	target_position = target_pos
	should_follow = true
	target_set.emit()

func _physics_process(delta: float) -> void:
	if disabled: return
	
	if should_follow and target_position.length() < limit:
		var direction = target_position - global_position
		velocity = direction.normalized() * speed
		
		if direction.length() <= speed * delta:
			velocity = Vector2.ZERO
			global_position = target_position
			should_follow = false
			target_reached.emit()
	
		move_and_slide()
