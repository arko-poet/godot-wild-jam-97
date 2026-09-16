extends Node

signal gem_dropped
signal upgrade_purchased


func drop_gem(gem_id: int, amount: int, global_position: Vector2) -> void:
	gem_dropped.emit(gem_id, amount, global_position)


func purchase_upgrade(upgrade_name: String, amount: float, upgrade_cost: int) -> void:
	upgrade_purchased.emit(upgrade_name, amount, upgrade_cost)
