extends Node
#
signal resource_collected

func collect_resource(resource_id : int, amount : int, drop_global_position : Vector2) -> void:
	resource_collected.emit(resource_id, amount, drop_global_position)

signal upgrade_changed

func emit_upgrade_changed(upgrade_name : String, amount : float) -> void:
	upgrade_changed.emit(upgrade_name, amount)

#func _ready() -> void:
#	Events.upgrade_changed.connect(function...)

#func on_upgrade_change...whatevernamething(upgrade_name, value):
#	if ugprade_name == "hardcoded value":
#	some operation with value ex: -> export variable = value
