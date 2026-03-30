extends Node
class_name FixedInventory

signal data_ready
signal data_updated

@export var size : int = 64
var data : Array[Dictionary]

func _ready() -> void:
	resize_inventory(size)

func resize_inventory(data_size : int) -> void:
	data.resize(data_size)
	data_ready.emit()

func add_item_at_index(index : int, item : Item, quantity : int = 0) -> void:
	var data_entry : Dictionary[Item, int] = { item: quantity }
	
	if data[index] == data_entry:
		data[index][item] += quantity
	else:
		data[index] = data_entry
	
	data_updated.emit()

func get_item_at_index(index : int) -> Item:
	var item_data : Dictionary = data[index]
	
	if not item_data.is_empty():
		return item_data.keys().get(0)
	else:
		return null
	
func remove_item_at_index(index : int, item : Item, quantity : int = 0) -> void:
	for i in range(0, quantity):
		if data[index][item] >= 1:
			data[index][index] -= 1
	
	data_updated.emit()

func has_item(item : Item, quantity : int = 0) -> bool:
	for slot_index in range(data.size()):
		if data[slot_index].has(item):
			if data[slot_index][item] >= quantity:
				return true
	return false

func find_item_index(item : Item) -> int:
	for slot_index in range(data.size()):
		if data[slot_index].has(item):
			return slot_index
	return -1
	
func find_empty_slot() -> int:
	for i in range(data.size()):
		if data[i].is_empty():
			return i
	return -1
