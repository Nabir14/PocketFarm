extends Node2D
class_name World

@export var farm_manager : FarmManager
@export var game_tick : Timer

func _ready() -> void:
	game_tick.timeout.connect(_on_game_tick)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_action"):
		var mouse_position : Vector2 = get_global_mouse_position()
		var tile_position : Vector2 = farm_manager.to_farm_position(mouse_position)
		
		if farm_manager.is_tile_empty(tile_position):
			farm_manager.place_crop(tile_position, load("res://gamefiles/resources/crops/carrot.tres"))
		elif farm_manager.is_tile_ready_for_harvest(tile_position):
			farm_manager.harvest_crop_at_tile(tile_position)

func _on_game_tick() -> void:
	farm_manager.update_crops()
