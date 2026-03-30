extends Node2D
class_name FarmManager

signal crop_planted(crop : Crop, tile_position : Vector2i)
signal crop_harvested(crop : Crop, tile_position : Vector2i)

@export_group("Farm Setup")
@export var farm_tilemap_layer : TileMapLayer
@export var crop_tilemap_layer : TileMapLayer
@export var farm_land_source_id : int = 2
@export var crop_source_id : int = 0
@export var chest_atlas_coords : Vector2i = Vector2i.ZERO
@export var exit_atlas_coords : Vector2i = Vector2i.ZERO

var planted_crops : Array[Dictionary]

func plant_crop(tile_position : Vector2i, crop : Crop) -> void:
	if is_tile_farm_land(tile_position) and is_tile_empty(tile_position):
		planted_crops.append({
			"resource": crop,
			"position": tile_position,
			"current_age": 0
		})
		
		crop_tilemap_layer.set_cell(tile_position, crop_source_id, crop.age_sprites[0])
		
		crop_planted.emit(crop, tile_position)

func harvest_crop(tile_position : Vector2i) -> void:
	if is_tile_ready_for_harvest(tile_position):
		for crop in planted_crops:
			if crop.position == tile_position:
				planted_crops.erase(crop)
				crop_tilemap_layer.erase_cell(tile_position)
				crop_harvested.emit(crop.resource, tile_position)
	

func update_crops() -> void:
	for crop in planted_crops:
		if is_crop_ready_for_harvest(crop.current_age, crop.resource.max_age):
			crop_tilemap_layer.set_cell(crop.position, crop_source_id, crop.resource.age_sprites[crop.resource.age_sprites.size() - 1])
		else:
			crop_tilemap_layer.set_cell(crop.position, crop_source_id, crop.resource.age_sprites[0])
		
		crop.current_age += 1

func is_tile_farm_land(tile_position : Vector2i) -> bool:
	if farm_tilemap_layer.get_cell_source_id(tile_position) == farm_land_source_id:
		return true
	else:
		return false

func is_tile_empty(tile_position : Vector2i) -> bool:
	var result : bool = false
	
	if crop_tilemap_layer.get_cell_atlas_coords(tile_position) == Vector2i(-1, -1):
		result = true
	
	for crop in planted_crops:
		if crop.position == tile_position:
			result = false
	
	return result

func is_tile_ready_for_harvest(tile_position : Vector2i) -> bool:
	for crop in planted_crops:
		if crop.position == tile_position:
			if is_crop_ready_for_harvest(crop.current_age, crop.resource.max_age):
				return true
			else:
				return false
	return false

func is_crop_ready_for_harvest(current_age : int, max_age : int) -> bool:
	if current_age >= max_age:
		return true
	else:
		return false

func to_farm_position(local_position : Vector2) -> Vector2i:
	return farm_tilemap_layer.local_to_map(local_position)
