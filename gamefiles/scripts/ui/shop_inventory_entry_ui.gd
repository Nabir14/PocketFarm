extends HBoxContainer
class_name ShopInventoryEntryUI

signal buy(item : Item)

@export var item : Item = null
@export var price : int = 0

func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL

func setup_entry() -> void:
	var icon : TextureRect = TextureRect.new()
	var label : Label = Label.new()
	var buy_button : Button = Button.new()
	
	buy_button.alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	if item:
		icon.texture = item.icon
		label.text = item.name+" ("+str(price)+" Coins)"
		
		buy_button.text = "Buy"
		buy_button.pressed.connect(_on_buy_clicked)
		
		self.add_child(icon)
		self.add_child(label)
		self.add_child(buy_button)

func _on_buy_clicked() -> void:
	buy.emit(item)
