extends AnimatedSprite2D

var attack_duration := 0.3


func _ready() -> void:
	var frame_count := sprite_frames.get_frame_count(&"attack")
	sprite_frames.set_animation_speed(&"attack", frame_count / attack_duration)

	play(&"attack")


func _on_animation_finished() -> void:
	queue_free()
