extends Node2D
class_name GameManager

@export var world : World
@export var windows_manager : WindowsManager

# Time
var spawner_current_time : int = 0

# Booleans
var is_inventory_open : bool = false
var is_settings_open : bool = false

# Scenes
var inventory_scene : PackedScene = load("res://gamefiles/scenes/ui/inventory_ui.tscn")

# Other Variables
var selected_item : Item
var inventory_ui : InventoryUI

func _ready() -> void:
	world.farm_manager.crop_planted.connect(_on_crop_planted)
	world.farm_manager.crop_harvested.connect(_on_crop_harvested)
	world.game_tick.timeout.connect(_on_game_tick)
	world.inventory_manager.inventory_systems_ready.connect(_on_inventory_system_ready)
	
	world.process_default()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_action"):
		world.process_action_once(self)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("mouse_action"):
		world.process_action(self)
	elif Input.is_action_pressed("mouse_action_s"):
		world.process_sub_action()
	
	$debug_ui/gold.text = str(world.main_currency.name)+"s: "+str(world.economy_system.current_balance[world.main_currency])

func _physics_process(_delta: float) -> void:
	world.process_entities()

# UI
func open_inventory() -> void:
	if not is_inventory_open:
		inventory_ui = inventory_scene.instantiate()
		inventory_ui.setup_user_inventory(world.inventory_manager.user_inventory, _on_user_inventory_slot_selected)
		inventory_ui.update_user_inventory_ui(world.inventory_manager.user_inventory)
		inventory_ui.setup_shop_inventory_ui(world.inventory_manager.shop_inventory, _on_item_bought)
		world.inventory_manager.user_inventory.data_updated.connect(_on_user_inventory_updated)
		world.inventory_manager.shop_inventory.data_updated.connect(_on_shop_inventory_updated)
		windows_manager.append_new_window(_on_inventory_closed, inventory_ui)
		
		is_inventory_open = true

func open_settings() -> void:
	pass

# Callbacks
func _on_game_tick() -> void:
	spawner_current_time += 1
	
	world.check_spawn_time(self)
	world.apply_upgrades()
	world.update_farm()

func _on_inventory_system_ready() -> void:
	pass

func _on_crop_planted(_crop : Crop, _tile_position : Vector2i) -> void:
	world.inventory_manager.user_inventory.remove_item(selected_item, 1)

func _on_crop_harvested(crop : Crop, _tile_position : Vector2i) -> void:
	var crop_price : int = world.price_list.crops[crop]
	world.economy_system.add_currency(world.main_currency, crop_price)

func _on_user_inventory_slot_selected(slot_data : Dictionary) -> void:
	selected_item = slot_data.item

func _on_user_inventory_updated() -> void:
	inventory_ui.update_user_inventory_ui(world.inventory_manager.user_inventory)

func _on_shop_inventory_updated() -> void:
	inventory_ui.setup_shop_inventory_ui(world.inventory_manager.shop_inventory, _on_item_bought)

func _on_item_bought(item : Item) -> void:
	var item_price : int = world.price_list.items[item]
	
	if world.economy_system.has_currency(world.main_currency, item_price):
		world.economy_system.remove_currency(world.main_currency, item_price)
		world.inventory_manager.user_inventory.add_item(item, 1)

func _on_inventory_closed() -> void:
	is_inventory_open = false
