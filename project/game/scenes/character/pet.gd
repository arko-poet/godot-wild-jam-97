class_name Pet
extends Node2D

signal mined

@onready var mining_timer: Timer = %MiningTimer
@onready var sprite: AnimatedSprite2D = %Sprite


func start_mining() -> void:
	mining_timer.start()
	sprite.play(&"attack")


func stop_mining() -> void:
	mining_timer.stop()
	sprite.play(&"idle")
	SfxController.stop_drill()


func _on_mining_timer_timeout() -> void:
	mined.emit()
	SfxController.play_drill()
