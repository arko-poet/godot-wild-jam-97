class_name UpgradesMenu
extends Control

@export var hide_offset: Vector2

var tween: Tween

@onready var upgrade_container: Control = %UpgradeContainer


func hide_menu() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position:y", -size.y, 0.5).\
	set_trans(Tween.TRANS_QUAD)


func show_menu() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position:y", 0.0, 0.5).\
	set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	unlock_next_upgrade()

	var upgrade: Upgrade = upgrade_container.get_child(0)
	upgrade.upgrade_button.grab_focus()


func gems_changed(gems: int) -> void:
	for upgrade in upgrade_container.get_children():
		if upgrade is Upgrade:
			upgrade.set_affordable(upgrade.get_cost() > gems)


func unlock_next_upgrade() -> void:
	for upgrade in upgrade_container.get_children():
		if upgrade is Upgrade:
			if not upgrade.visible:
				upgrade.show()
				break
#func try_grab_focus(gems: int) -> bool:
#for upgrade in upgrade_container.get_children():
#if upgrade is Upgrade:
#if upgrade.visible and gems >= upgrade.get_cost():
#upgrade.upgrade_button.grab_focus()
#return true
#
#return false
