class_name Gem
extends Node2D


func _ready() -> void:
	var tween = create_tween()
	
	#var target_position := get_viewport().get_camera_2d().position #- get_viewport_rect().size / 2
	tween.tween_property(self, ^"position:x", position.x - 400, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.finished.connect(_on_tween_finished)


func _on_tween_finished() -> void:
	Events.collect_gem()
	queue_free()
