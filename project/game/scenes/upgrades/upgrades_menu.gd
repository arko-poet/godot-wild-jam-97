class_name UpgradesMenu
extends Control

@export var hide_offset: Vector2

var tween: Tween

@onready var upgrade_container: GridContainer = %UpgradeContainer


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
