extends Control
class_name InventoryUI

@export var user_inventory_grid_ui : GridContainer
@export var shop_inventory_list_ui : VBoxContainer

var user_inventory_slots : Array[UserInventorySlotUI]
var shop_inventory_slots : Array[ShopInventoryEntryUI]

func setup_user_inventory(user_inventory : FixedInventory, callback : Callable) -> void:
	for index in range(user_inventory.data.size()):
		var slot : UserInventorySlotUI = UserInventorySlotUI.new()
		slot.slot_selected.connect(callback)
		user_inventory_slots.append(slot)
		user_inventory_grid_ui.add_child(slot)

func update_user_inventory_ui(user_inventory : FixedInventory) -> void:
	for slot_index in range(user_inventory_slots.size()):
		var item : Item = user_inventory.get_item_at_index(slot_index)
		if item:
			user_inventory_slots[slot_index].text = item.name+" (x"+str(user_inventory.get_item_quantity(item))+")"
			user_inventory_slots[slot_index].icon = item.icon
			user_inventory_slots[slot_index].item = item
		else:
			user_inventory_slots[slot_index].text = ""
			user_inventory_slots[slot_index].icon = null
			user_inventory_slots[slot_index].item = null
		

func setup_shop_inventory_ui(shop_inventory : DynamicInventory, callback : Callable) -> void:
	for entry in shop_inventory_slots:
		entry.queue_free()
	
	for item in shop_inventory.data:
		var entry : ShopInventoryEntryUI = ShopInventoryEntryUI.new()
		entry.item = item
		entry.price = shop_inventory.data[item]
		entry.buy.connect(callback)
		entry.setup_entry()
		shop_inventory_slots.append(entry)
		shop_inventory_list_ui.add_child(entry)
