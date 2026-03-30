extends Node2D
class_name World

@export var farm_manager : FarmManager
@export var inventory_manager : InventoryManager
@export var game_tick : Timer

@export_group("UI Elements Management")
@export var windows_parent_ui : Node2D

var _selected_seed_item : SeedItem = null

func _ready() -> void:
	game_tick.timeout.connect(_on_game_tick)
	inventory_manager.inventory_systems_ready.connect(_on_inventory_system_ready)
	
	inventory_manager.setup_inventory_systems()

func _on_inventory_system_ready() -> void:
	inventory_manager.user_inventory.add_item_at_index(0, load("res://gamefiles/resources/seeds/carrot_seed.tres"), 1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_action"):
		var mouse_position : Vector2 = get_global_mouse_position()
		var tile_position : Vector2i = farm_manager.to_farm_position(mouse_position)
		
		if farm_manager.crop_tilemap_layer.get_cell_atlas_coords(tile_position) == farm_manager.exit_atlas_coords:
			get_tree().quit()
		elif farm_manager.crop_tilemap_layer.get_cell_atlas_coords(tile_position) == farm_manager.chest_atlas_coords:
			var inventory_ui : InventoryUI = load("res://gamefiles/scenes/ui/inventory_ui.tscn").instantiate()
			inventory_ui.setup_user_inventory(inventory_manager.user_inventory, _on_user_inventory_slot_selected)
			inventory_ui.update_user_inventory_ui(inventory_manager.user_inventory)
			inventory_manager.user_inventory.data_updated.connect(inventory_ui.update_user_inventory_ui.bind(inventory_manager.user_inventory))
			append_new_window(inventory_ui)

func _process(_delta: float) -> void:
	var mouse_position : Vector2 = get_global_mouse_position()
	var tile_position : Vector2i = farm_manager.to_farm_position(mouse_position)
	
	if Input.is_action_pressed("mouse_action"):
		if not _selected_seed_item: return
		
		if farm_manager.is_tile_empty(tile_position):
			farm_manager.place_crop(tile_position, _selected_seed_item.crop)
	elif Input.is_action_pressed("mouse_action_s"):
		farm_manager.harvest_crop_at_tile(tile_position)

func _on_game_tick() -> void:
	farm_manager.update_crops()

func append_new_window(window_child : Control):
	var window = Window.new()
	window.always_on_top = true
	window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	window.unresizable = true
	window.size = Vector2i(640, 480)
	window.close_requested.connect(_on_window_close_requested.bind(window))
	window.add_child(window_child)
	windows_parent_ui.add_child(window)

func _on_window_close_requested(window : Window) -> void:
	window.queue_free()

func _on_user_inventory_slot_selected(item : Item) -> void:
	_selected_seed_item = item
