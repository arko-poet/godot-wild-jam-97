class_name Upgrade
extends PanelContainer

@export_group("main")
@export var upgrade_name: String
@export var upgrade_count: int
@export var upgrade_cap: int

@export_group("cost structure")
@export var consume_resource_id: int
@export var base_cost: int = 0
@export var cost_linear_multiplier: float = 0
@export var cost_exponential_base: float = 1

@export_group("emit amount")
@export var base_amount: float = 1.0
@export var percent_amount_change: float = 0
@export var flat_amount_change: float = 1.0

@onready var upgrade_button: Button = %UpgradeButton
@onready var upgrade_count_label: Label = %UpgradeCountLabel


func _ready() -> void:
	_update()


func get_cost() -> int:
	return int(
		base_cost + upgrade_count * cost_linear_multiplier
		+ pow(upgrade_count, cost_exponential_base)
	)


func get_amount() -> float:
	return base_amount + upgrade_count * (percent_amount_change + flat_amount_change)


func set_affordable(affordable: bool) -> void:
	upgrade_button.disabled = affordable
	if upgrade_count == upgrade_cap:
		upgrade_button.disabled = true


func _update():
	if not is_inside_tree():
		return

	upgrade_button.text = str(upgrade_name, "\n Cost: ", get_cost(), "g")

	if upgrade_cap > 0:
		upgrade_count_label.text = str(upgrade_count, "/", upgrade_cap)
	else:
		upgrade_count_label.text = str(upgrade_count)


func _on_upgrade_button_pressed() -> void:
	Events.purchase_upgrade(upgrade_name, get_amount(), get_cost())

	upgrade_count += 1

	_update()
