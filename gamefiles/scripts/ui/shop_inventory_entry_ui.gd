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
	
	icon.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	icon.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.size_flags_stretch_ratio = 6.
	
	buy_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
	buy_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	buy_button.alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	if item:
		icon.texture = item.icon
		label.text = item.name+"\nPrice: "+str(price)
		
		if item is SeedItem:
			label.text += "\nMax Age: "+str(item.crop.max_age)
		elif item is UpgradeItem:
			label.text += "\nDuration: "+str(item.upgrade.upgrade_cooldown_s)+"s"
		
		buy_button.text = "Buy"
		buy_button.pressed.connect(_on_buy_clicked)
		
		self.add_child(icon)
		self.add_child(label)
		self.add_child(buy_button)

func _on_buy_clicked() -> void:
	buy.emit(item)
