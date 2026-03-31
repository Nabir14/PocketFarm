extends Node
class_name DynamicInventory

signal data_updated

var data : Dictionary

func add_item(item : Item, quantity : int) -> void:
	if data.has(item):
		data[item] += quantity
	else:
		data[item] = quantity
	
	data_updated.emit()

func remove_item(item : Item, quantity : int) -> void:
	for i in range(quantity):
		if data[item] > 0:
			data[item] -= quantity
		else:
			data.erase(item)
	
	data_updated.emit()
