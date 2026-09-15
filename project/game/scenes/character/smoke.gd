extends AnimatedSprite2D

var dash_duration := 0.3


func _ready() -> void:
	var frame_count := sprite_frames.get_frame_count(&"dash")
	sprite_frames.set_animation_speed(&"dash", frame_count / dash_duration)

	play(&"dash")


func _on_animation_finished() -> void:
	queue_free()
