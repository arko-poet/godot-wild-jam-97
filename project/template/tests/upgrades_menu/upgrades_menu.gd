extends Control

@onready var toggle_button : Button = %ToggleOffset
@export var hide_offset : Vector2
var tween : Tween

func _ready() -> void:
	#GlobalSignals.signal_name.connect(_func)
	toggle_button.pressed.connect(
		func():
			if toggle_button.button_pressed:
				if tween : tween.kill()
				tween = create_tween()
				tween.tween_property(get_child(0), "offset_transform_position", Vector2.ZERO, 0.5).\
				set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			else:
				if tween : tween.kill()
				tween = create_tween()
				tween.tween_property(get_child(0), "offset_transform_position", hide_offset, 0.5).\
				set_trans(Tween.TRANS_QUAD),
	)
