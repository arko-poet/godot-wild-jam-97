extends Node

signal gem_dropped
signal upgrade_purchased
signal depth_increased


func drop_gem(ore_resource: OreResource, global_position: Vector2) -> void:
	gem_dropped.emit(ore_resource, global_position)


func purchase_upgrade(upgrade_name: String, amount: float, upgrade_cost: int) -> void:
	upgrade_purchased.emit(upgrade_name, amount, upgrade_cost)


func increase_depth() -> void:
	depth_increased.emit()
