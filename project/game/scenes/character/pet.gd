class_name Pet
extends Node2D

signal mined

@onready var mining_timer: Timer = %MiningTimer


func start_mining() -> void:
	mining_timer.start()


func stop_mining() -> void:
	mining_timer.stop()


func _on_mining_timer_timeout() -> void:
	mined.emit()
