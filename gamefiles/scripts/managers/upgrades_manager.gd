extends Node
class_name UpgradesManager

var upgrades : Array[Upgrade]

func apply_upgrade(upgrade : Upgrade) -> void:
	upgrades.append(upgrade)
	get_tree().create_timer(upgrade.upgrade_cooldown_s).timeout.connect(_on_upgrade_expire.bind(upgrade))

func remove_upgrade(upgrade : Upgrade) -> void:
	upgrades.erase(upgrade)

func _on_upgrade_expire(upgrade : Upgrade) -> void:
	remove_upgrade(upgrade)
