extends Node
#
signal resource_collected

func collect_resource(resource_id : int, amount : int, drop_global_position : Vector2) -> void:
	resource_collected.emit(resource_id, amount, drop_global_position)
