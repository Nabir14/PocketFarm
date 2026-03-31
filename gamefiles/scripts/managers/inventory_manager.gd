extends Node2D
class_name InventoryManager

signal inventory_systems_ready

@export var user_inventory : FixedInventory
@export var shop_inventory : DynamicInventory

func setup_inventory_systems() -> void:
	user_inventory.resize_inventory(9)
	
	inventory_systems_ready.emit()
