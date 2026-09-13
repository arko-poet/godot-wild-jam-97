extends Node

signal gem_collected


func collect_gem() -> void:
	gem_collected.emit()
