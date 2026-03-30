extends Control
class_name InventoryUI

@export var user_inventory_grid_ui : GridContainer

var user_inventory_slots : Array[Dictionary]

func setup_user_inventory(user_inventory : FixedInventory, callback : Callable) -> void:
	for index in range(0, user_inventory.data.size()):
		var button : Button = Button.new()
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		user_inventory_slots.append({
			"button": button,
			"item": null
		})
		
		user_inventory_slots[index].button.pressed.connect(callback.bind(user_inventory_slots[index].item))
		
		user_inventory_grid_ui.add_child(button)
	

func update_user_inventory_ui(user_inventory : FixedInventory) -> void:
	for slot in user_inventory_slots:
		var item = user_inventory.get_item_at_index(user_inventory_slots.find(slot))
		if item:
			slot.button.icon = item.icon
			slot.item = item
