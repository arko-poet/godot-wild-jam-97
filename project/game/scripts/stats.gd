class_name Stats
extends RefCounted

var base_damage := 1
var dash_duration := 0.5
var pet_base_damage := 1
var doom_time := 10.0


func _init() -> void:
	Events.upgrade_purchased.connect(_on_upgrade_purchased)


func _on_upgrade_purchased(upgrade_name: String, amount: float, _cost: int) -> void:
	match upgrade_name:
		"base_damage":
			base_damage = int(amount)
		"dash_duration":
			dash_duration = amount
		"pet_base_damage":
			pet_base_damage = int(amount)
		"doom_time":
			doom_time = amount
		_:
			push_error("Upgrade Name '%s' doesn't have a matching property" % upgrade_name)
