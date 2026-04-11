extends Node2D
class_name World

@export_group("World Management")
@export var map_limit : Vector2 = Vector2(0., 0.)
@export var game_tick : Timer

@export_group("Managers And Systems")
@export var farm_manager : FarmManager
@export var inventory_manager : InventoryManager
@export var upgrades_manager : UpgradesManager
@export var economy_system : EconomySystem

@export_group("Economy Management")
@export var main_currency : CurrencyItem
@export var price_list : PriceList

@export_group("Entity Management")
@export var random_spawner : RandomSpawner2D
@export var entity_scenes : Dictionary[PackedScene, float]

@export_group("Time Management")
@export var spawner_cooldown_s : int = 1

func process_default() -> void:
	inventory_manager.setup_inventory_systems()
	inventory_manager.add_items_in_shop_from_list(price_list, main_currency)
	economy_system.add_currency(main_currency, round(100 * main_currency.currency_weight))

func process_action_once(game_manager : GameManager) -> void:
	var mouse_position : Vector2 = get_global_mouse_position()
	var tile_position : Vector2i = farm_manager.to_farm_position(mouse_position)
	
	for object in random_spawner.spawned_objects:
		if (object.global_position - mouse_position).length() < 10.:
			random_spawner.remove_object(object)
			economy_system.add_currency(main_currency, 5)
	
	if farm_manager.crop_tilemap_layer.get_cell_atlas_coords(tile_position) == farm_manager.exit_atlas_coords:
		get_tree().quit()
	elif farm_manager.crop_tilemap_layer.get_cell_atlas_coords(tile_position) == farm_manager.chest_atlas_coords:
		game_manager.open_inventory()

func process_action(game_manager : GameManager) -> void:
	if not game_manager.selected_item: return
	if not inventory_manager.user_inventory.get_item_quantity(game_manager.selected_item) > 0:
		game_manager.selected_item = null
		return
	
	var mouse_position : Vector2 = get_global_mouse_position()
	var tile_position : Vector2i = farm_manager.to_farm_position(mouse_position)
	
	if game_manager.selected_item is SeedItem:
		if farm_manager.is_tile_empty(tile_position):
			farm_manager.plant_crop(tile_position, game_manager.selected_item.crop)
	elif game_manager.selected_item is UpgradeItem:
		upgrades_manager.apply_upgrade(game_manager.selected_item.upgrade)

func process_sub_action() -> void:
	var mouse_position : Vector2 = get_global_mouse_position()
	var tile_position : Vector2i = farm_manager.to_farm_position(mouse_position)
	
	farm_manager.harvest_crop(tile_position)

func process_entities() -> void:
	for object in random_spawner.spawned_objects:
		if object is TopdownNpc2D:
			if not object.disabled:
				var enemy_pos = farm_manager.crop_tilemap_layer.local_to_map(object.global_position)
				
				if not farm_manager.is_tile_empty(enemy_pos):
					farm_manager.remove_crop(enemy_pos)

func check_spawn_time(game_manager : GameManager) -> void:
	if game_manager.spawner_current_time >= spawner_cooldown_s:
		random_spawner.randomly_spawn_object(entity_scenes, map_limit)
		game_manager.spawner_current_time = 0

func apply_upgrades() -> void:
	for upgrade in upgrades_manager.upgrades:
		match upgrade.type:
			Upgrade.UpgradeTypes.GROWTH_BOOST:
				for i in range(round(upgrade.upgrade_weight)):
					update_farm()

func update_farm() -> void:
	farm_manager.update_crops()
