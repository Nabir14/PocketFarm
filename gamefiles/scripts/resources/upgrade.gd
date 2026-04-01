extends Resource
class_name Upgrade

enum UpgradeTypes {
	GROWTH_BOOST,
	QUALITY_BOOST,
	PROTECTION
}

@export var type : UpgradeTypes
@export var upgrade_weight : float = 1.0
@export var upgrade_cooldown_s : float = 10.0
