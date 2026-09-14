class_name Stats extends RefCounted


var base_damage: int

func _init() -> void:
	Events.upgrade_changed.connect(_on_upgrade_changed)
	

func _on_upgrade_changed(upgrade_name : String, amount : float) -> void:
	match upgrade_name:
		"base_damage":
			base_damage = int(amount)
		_:
			push_error("Upgrade Name '%s' doesn't have a matching property" % upgrade_name)
