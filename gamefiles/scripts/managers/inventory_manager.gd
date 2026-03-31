extends Node2D
class_name InventoryManager

signal inventory_systems_ready

@export var user_inventory : FixedInventory
@export var shop_inventory : DynamicInventory

func setup_inventory_systems() -> void:
	user_inventory.resize_inventory(9)
	
	inventory_systems_ready.emit()

func add_items_in_shop_from_list(list : PriceList, currency : CurrencyItem) -> void:
	for item in list.items:
		shop_inventory.add_item(item, round(list.items[item] * currency.currency_weight))
