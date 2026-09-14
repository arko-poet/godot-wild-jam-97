class_name Stats extends RefCounted


var base_damage := 1
var dash_duration := 0.5

func _init() -> void:
	Events.upgrade_changed.connect(_on_upgrade_changed)
	

func _on_upgrade_changed(upgrade_name : String, amount : float) -> void:
	match upgrade_name:
		"base_damage":
			base_damage = int(amount)
		"dash_duration":
			dash_duration = amount
		_:
			push_error("Upgrade Name '%s' doesn't have a matching property" % upgrade_name)
