class_name UpgradesMenu
extends Control

@export var gems = [0]
@export var hide_offset: Vector2

var tween: Tween

@onready var toggle_button: Button = %ToggleOffset
@onready var resource_counters: Control = %ResourceCounters


func _ready() -> void:
	@warning_ignore("unused_parameter")
	Events.resource_collected.connect(
		func on_resource_collected(resource_id, amount, drop_global_position):
			resource_counters.get_child(resource_id).get_child(1).text = str(
				":",
				gems[resource_id] + amount,
			)
			gems[resource_id] += amount,
	)
	toggle_button.pressed.connect(
		func():
			if toggle_button.button_pressed:
				show_menu()
			else:
				hide_menu(),
	)
	for r in gems.size():
		resource_counters.get_child(r).get_child(1).text = str(":", gems[r])


func hide_menu() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(get_child(0), "offset_transform_position", hide_offset, 0.5).\
	set_trans(Tween.TRANS_QUAD)


func show_menu() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(get_child(0), "offset_transform_position", Vector2.ZERO, 0.5).\
	set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func try_resource_transaction(resource_id: int, amount: int) -> bool:
	var temp = gems[resource_id] + amount
	if temp >= 0:
		gems[resource_id] = temp
		resource_counters.get_child(resource_id).get_child(1).text = str(":", gems[resource_id])
		return true
	return false
