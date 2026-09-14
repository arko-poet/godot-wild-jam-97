class_name UpgradesMenu
extends Control

var gems = [0,0,0]

@onready var toggle_button : Button = %ToggleOffset
@onready var resource_counters : Control = %ResourceCounters
@export var hide_offset : Vector2
var tween : Tween

func _ready() -> void:
	
	
	@warning_ignore("unused_parameter")
	Events.resource_collected.connect(
		func on_resource_collected(resource_id, amount, drop_global_position):
			resource_counters.get_child(resource_id).get_child(1).text = str(":",gems[resource_id] + amount)
			gems[resource_id] += amount
	)
	toggle_button.pressed.connect(
		func():
			if toggle_button.button_pressed:
				show_menu()
			else:
				hide_menu()	
	)

func hide_menu() -> void:
	if tween : tween.kill()
	tween = create_tween()
	tween.tween_property(get_child(0), "offset_transform_position", hide_offset, 0.5).\
	set_trans(Tween.TRANS_QUAD)


func show_menu() -> void:
	if tween : tween.kill()
	tween = create_tween()
	tween.tween_property(get_child(0), "offset_transform_position", Vector2.ZERO, 0.5).\
	set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
