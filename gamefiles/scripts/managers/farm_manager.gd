extends Node2D
class_name FarmManager

@export_group("Farm Setup")
@export var farm_tilemap_layer : TileMapLayer
@export var crop_tilemap_layer : TileMapLayer
@export var farm_land_source_id : int = 2
@export var crop_source_id : int = 0

var placed_crops : Array[Dictionary]

func place_crop(tile_position : Vector2i, crop : Crop) -> void:
	if is_tile_farm_land(tile_position) and is_tile_empty(tile_position):
		placed_crops.append({
			"resource": crop,
			"position": tile_position,
			"current_age": 0
		})

func update_crops() -> void:
	for crop in placed_crops:
		if crop.current_age >= crop.resource.max_age:
			crop_tilemap_layer.set_cell(crop.position, crop_source_id, crop.age_sprites[crop.resource.age_sprites.size() - 1])
		else:
			crop_tilemap_layer.set_cell(crop.position, crop_source_id, crop.age_sprites[0])
		
		crop.current_age += 1

func is_tile_farm_land(tile_position : Vector2i) -> bool:
	if farm_tilemap_layer.get_cell_source_id(tile_position) == farm_land_source_id:
		return true
	else:
		return false

func is_tile_empty(tile_position : Vector2) -> bool:
	if crop_tilemap_layer.get_cell_atlas_coords(tile_position) == Vector2i(-1, -1):
		return true
	else:
		return false
