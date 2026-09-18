class_name FloatingText
extends Node2D

var text: String
var text_color: Color
var font_size := 16

@onready var _label: Label = %Label


# ensure position and label text is set before adding node to the scene tree
func _ready() -> void:
	_label.text = text
	if text_color:
		_label.add_theme_color_override("font_color", text_color)

	_label.add_theme_font_size_override(&"font_size", font_size)

	var tween := create_tween()
	tween.set_parallel()

	var original_scale := _label.scale
	_label.scale = original_scale * 0.6
	var new_scale := original_scale * 1.15

	var drift_x = randf_range(-12.0, 12.0)
	var drift_y = randf_range(-32.0, -24.0)
	tween.tween_property(_label, "scale", new_scale, 0.12).set_trans(Tween.TRANS_BACK).set_ease(
		Tween.EASE_OUT
	)
	tween \
			.tween_property(_label, "scale", original_scale, 0.10) \
			.set_delay(0.12) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_OUT)
	tween.tween_property(_label, "position", Vector2(drift_x, drift_y), 0.6).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_OUT
	)
	tween.tween_property(self, "modulate:a", 0.0, 1)
	tween.finished.connect(queue_free)
