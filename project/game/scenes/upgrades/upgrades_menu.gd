class_name UpgradesMenu
extends Control

@export var hide_offset: Vector2

var tween: Tween

@onready var toggle_button: Button = %ToggleOffset
@onready var resource_counters: Control = %ResourceCounters
@onready var upgrade_container: GridContainer = %UpgradeContainer


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


func gems_changed(gems: int) -> void:
	for upgrade in upgrade_container.get_children():
		if upgrade is Upgrade:
			upgrade.upgrade_button.disabled = upgrade.total_cost > gems


func _on_toggle_offset_pressed() -> void:
	if toggle_button.button_pressed:
		show_menu()
	else:
		hide_menu()
