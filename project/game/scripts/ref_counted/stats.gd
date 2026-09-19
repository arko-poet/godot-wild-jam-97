class_name Stats
extends RefCounted

var base_damage := 1
var increased_damge := 0.0
var dash_duration := 0.5
var pet_base_damage := 1
var hp := 10.0
var pickaxe := 0
var crit_chance := 0.05
var crit_damage := 2.0
var attack_duration := 0.5
var auto_attack := false
var pet_unlocked := false
var pet_increased_damage := 0.0
var pet_crit_chance := 0.05
var pet_crit_damage := 2.0
var pet_attack_duration := 0.1
var hp_regen := 0.0
var ore_rarity := 0.05


func _init() -> void:
	Events.upgrade_purchased.connect(_on_upgrade_purchased)


func _on_upgrade_purchased(upgrade_name: String, amount: float, _cost: int) -> void:
	match upgrade_name:
		"Extra Damage":
			base_damage = int(amount)
		"Dash Speed":
			dash_duration = amount
		"Drill Dmg+":
			pet_base_damage = int(amount)
		"HP":
			hp = amount
		"Blood Pick":
			pickaxe = int(amount)
		"Aether Pick":
			pickaxe = int(amount)
		"More Damage":
			increased_damge = amount
		"Crit Chance":
			crit_chance = amount
		"Crit Damage":
			crit_damage = amount
		"Attack Speed":
			attack_duration = amount
		"Auto Mining":
			auto_attack = true
		"Drill Buddy":
			pet_unlocked = true
		"Drill Dmg%":
			pet_increased_damage = amount
		"Drill Crit%":
			pet_crit_chance = amount
		"Drill CritDmg":
			pet_crit_damage = amount
		"Drill Speed":
			pet_attack_duration = amount
		"HP Regen":
			hp_regen = amount
		"Gem Rarity":
			ore_rarity = amount
		_:
			push_error("Upgrade Name '%s' doesn't have a matching property" % upgrade_name)
