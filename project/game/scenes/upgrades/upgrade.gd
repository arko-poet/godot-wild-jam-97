class_name Upgrade
extends PanelContainer

@export_group("base")
@export var upgrade_name: String
@export var upgrade_cap: int = 10

@export_group("cost")
@export var consume_resource_id: int
@export var cost_base: int = 1
@export var cost_linear_coefficient: float = 1.0
@export var cost_exponential_coefficient: float
@export var cost_exponent: float

@export_group("output")
@export var output_base: float = 1.0
@export var output_flat_change: float = 1.0
@export var output_percentage_change: float

var upgrade_count: int

@onready var upgrade_button: Button = %UpgradeButton
@onready var upgrade_count_label: Label = %UpgradeCountLabel


func _ready() -> void:
	_update()


func get_cost() -> int:
	return int(
		cost_base + cost_linear_coefficient * upgrade_count
		+ cost_exponential_coefficient * pow(upgrade_count, cost_exponent)
	)


func get_output() -> float:
	return output_base + upgrade_count * (output_flat_change + output_percentage_change)


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
	upgrade_count += 1

	_update()

	Events.purchase_upgrade(upgrade_name, get_output(), get_cost())
