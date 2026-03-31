extends Node
class_name EconomySystem

var current_balance : Dictionary[CurrencyItem, int]

func add_currency(currency : CurrencyItem, quantity : int) -> void:
	if current_balance.has(currency):
		current_balance[currency] += quantity
	else:
		current_balance[currency] = quantity

func remove_currency(currency : CurrencyItem, quantity : int) -> void:
	if has_currency(currency, quantity):
		current_balance[currency] -= quantity
	else:
		current_balance.erase(currency)

func has_currency(currency : CurrencyItem, quantity : int) -> bool:
	if current_balance.has(currency):
		if current_balance[currency] >= quantity:
			return true
		else:
			return false
	else:
		return false
