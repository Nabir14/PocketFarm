extends Node2D
class_name World

@export var farm_manager : FarmManager
@export var inventory_manager : InventoryManager
@export var game_tick : Timer
@export var economy_system : EconomySystem

@export_group("UI Elements Management")
@export var windows_parent_ui : Node2D
@export var windows_child_temp_parent : Node2D

@export_group("Economy Management")
@export var main_currency : CurrencyItem
@export var price_list : PriceList

var selected_item : Item = null
var inventory_ui : InventoryUI = null

var is_inventory_open : bool = false

func _ready() -> void:
	farm_manager.crop_planted.connect(_on_crop_planted)
	farm_manager.crop_harvested.connect(_on_crop_harvested)
	game_tick.timeout.connect(_on_game_tick)
	inventory_manager.inventory_systems_ready.connect(_on_inventory_system_ready)
	
	process_default()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_action"):
		var mouse_position : Vector2 = get_global_mouse_position()
		var tile_position : Vector2i = farm_manager.to_farm_position(mouse_position)
		
		if farm_manager.crop_tilemap_layer.get_cell_atlas_coords(tile_position) == farm_manager.exit_atlas_coords:
			get_tree().quit()
		elif farm_manager.crop_tilemap_layer.get_cell_atlas_coords(tile_position) == farm_manager.chest_atlas_coords:
			if not is_inventory_open:
				is_inventory_open = true
				
				if not inventory_ui:
					inventory_ui = load("res://gamefiles/scenes/ui/inventory_ui.tscn").instantiate()
					inventory_ui.setup_user_inventory(inventory_manager.user_inventory, _on_user_inventory_slot_selected)
					inventory_ui.update_user_inventory_ui(inventory_manager.user_inventory)
					inventory_ui.setup_shop_inventory_ui(inventory_manager.shop_inventory, _on_item_bought)
					inventory_manager.user_inventory.data_updated.connect(_on_user_inventory_updated)
					inventory_manager.shop_inventory.data_updated.connect(_on_shop_inventory_updated)
					append_new_window(_on_inventory_closed, inventory_ui)
				else:
					append_new_window(_on_inventory_closed)

func _process(_delta: float) -> void:
	var mouse_position : Vector2 = get_global_mouse_position()
	var tile_position : Vector2i = farm_manager.to_farm_position(mouse_position)
	
	if Input.is_action_pressed("mouse_action"):
		if not selected_item: return
		if not inventory_manager.user_inventory.get_item_quantity(selected_item) > 0:
			selected_item = null
			return
		if not farm_manager.is_tile_empty(tile_position): return
		
		if selected_item is SeedItem:
			farm_manager.plant_crop(tile_position, selected_item.crop)
	elif Input.is_action_pressed("mouse_action_s"):
		farm_manager.harvest_crop(tile_position)
	
	$debug_ui/gold.text = str(main_currency.name)+"s: "+str(economy_system.current_balance[main_currency])

func process_default() -> void:
	inventory_manager.setup_inventory_systems()
	inventory_manager.add_items_in_shop_from_list(price_list, main_currency)
	economy_system.add_currency(main_currency, round(100 * main_currency.currency_weight))

func append_new_window(callback : Callable, window_child : Control = null):
	var window = Window.new()
	window.always_on_top = true
	window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	window.unresizable = true
	window.size = Vector2i(640, 480)
	window.close_requested.connect(_on_window_close_requested.bind(window, callback))
	
	var children = windows_child_temp_parent.get_children()
	for child in children:
		child.reparent(window)
	
	if window_child:
		window.add_child(window_child)
	
	windows_parent_ui.add_child(window)

func _on_game_tick() -> void:
	farm_manager.update_crops()

func _on_inventory_system_ready() -> void:
	pass

func _on_crop_planted(_crop : Crop, _tile_position : Vector2i) -> void:
	inventory_manager.user_inventory.remove_item(selected_item, 1)

func _on_crop_harvested(crop : Crop, _tile_position : Vector2i) -> void:
	var crop_price : int = price_list.crops[crop]
	economy_system.add_currency(main_currency, crop_price)

func _on_window_close_requested(window : Window, callback : Callable) -> void:
	var children = window.get_children()
	for child in children:
		child.reparent(windows_child_temp_parent)
	
	window.queue_free()
	callback.call()

func _on_user_inventory_slot_selected(slot_data : Dictionary) -> void:
	selected_item = slot_data.item

func _on_user_inventory_updated() -> void:
	inventory_ui.update_user_inventory_ui(inventory_manager.user_inventory)

func _on_shop_inventory_updated() -> void:
	inventory_ui.setup_shop_inventory_ui(inventory_manager.shop_inventory, _on_item_bought)

func _on_item_bought(item : Item) -> void:
	var item_price : int = price_list.items[item]
	
	if economy_system.has_currency(main_currency, item_price):
		economy_system.remove_currency(main_currency, item_price)
		inventory_manager.user_inventory.add_item(item, 1)
	

func _on_inventory_closed() -> void:
	is_inventory_open = false
