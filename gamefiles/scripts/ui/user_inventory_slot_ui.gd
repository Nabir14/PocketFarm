extends Button
class_name UserInventorySlotUI

signal slot_selected(slot_data : Dictionary)

@export var slot_index : int = 0
@export var item : Item = null

func _ready() -> void:
	icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	pressed.connect(_on_slot_selected)
	

func _on_slot_selected() -> void:
	slot_selected.emit({
		"slot_index": 0,
		"item": item
	})
