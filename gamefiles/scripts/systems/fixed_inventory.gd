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

func add_item(item : Item, quantity : int = 0) -> void:
	var index = find_empty_slot()
	if index >= 0:
		add_item_at_index(index, item, quantity)

func remove_item(item : Item, quantity : int = 0) -> void:
	var index = find_item_index(item)
	if index >= 0:
		remove_item_at_index(index, item, quantity)

func add_item_at_index(index : int, item : Item, quantity : int = 0) -> void:
	var data_entry : Dictionary = { item: quantity }
	
	if data[index] == data_entry:
		data[index][item] += quantity
	else:
		data[index] = data_entry
	
	data_updated.emit()

func remove_item_at_index(index : int, item : Item, quantity : int = 0) -> void:
	for i in range(quantity):
		if data[index][item] > 0:
			data[index][item] -= 1
			
			if data[index][item] <= 0: data[index] = {}
		
	data_updated.emit()

func has_item(item : Item, quantity : int = 0) -> bool:
	for index in range(data.size()):
		if data[index].has(item):
			if data[index][item] >= quantity:
				return true
	return false

func find_item_index(item : Item) -> int:
	for index in range(data.size()):
		if data[index].has(item):
			return index
	return -1
	
func find_empty_slot() -> int:
	for index in range(data.size()):
		if data[index].is_empty():
			return index
	return -1

func get_item_at_index(index : int) -> Item:
	var item_data : Dictionary = data[index]
	
	if not item_data.is_empty():
		return item_data.keys().get(0)
	else:
		return null

func get_item_quantity(target_item : Item) -> int:
	for index in range(data.size()):
		if data[index].has(target_item):
			return data[index][target_item]
		else:
			return -1
	return -1
