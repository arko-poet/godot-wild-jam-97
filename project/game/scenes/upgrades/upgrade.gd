class_name Upgrade
extends PanelContainer

signal upgrade_parameters_changed()

@export_group("main")
@export var upgrade_name: String:
	set(value):
		upgrade_name = value
		upgrade_parameters_changed.emit()
@export var current_upgrade_count: int:
	set(value):
		current_upgrade_count = value
		calculate_total_amount()
		calculate_total_cost()
		upgrade_parameters_changed.emit()
@export var upgrade_cap: int = 0:
	set(value):
		upgrade_cap = value
		upgrade_parameters_changed.emit()

@export_group("cost structure")
@export var consume_resource_id: int = 0
@export var base_cost: int = 0:
	set(value):
		base_cost = value
		calculate_total_cost()
		upgrade_parameters_changed.emit()
@export var cost_exponential_base: float = 1:
	set(value):
		cost_exponential_base = value
		calculate_total_cost()
		upgrade_parameters_changed.emit()
@export var cost_linear_multiplier: float = 0:
	set(value):
		cost_linear_multiplier = value
		calculate_total_cost()
		upgrade_parameters_changed.emit()
@export var total_cost: int = 1

@export_group("emit amount")
@export var use_upgrade_count: bool = true ##otherwise emit special value caluclated by other parameters
@export var base_amount: float = 0:
	set(amount):
		base_amount = amount
		calculate_total_amount()
		upgrade_parameters_changed.emit()
@export var percent_amount_change: float = 0:
	set(amount):
		percent_amount_change = amount
		calculate_total_amount()
		upgrade_parameters_changed.emit()
@export var flat_amount_change: float = 0:
	set(amount):
		flat_amount_change = amount
		calculate_total_amount()
		upgrade_parameters_changed.emit()
@export var total_amount: float = 0

var upgrades_menu: UpgradesMenu

@onready var upgrade_button: Button = %UpgradeButton
@onready var upgrade_count_label: Label = %UpgradeCountLabel


func _ready() -> void:
	upgrades_menu = owner
	upgrade_parameters_changed.connect(update_upgrade)

	update_upgrade()


func calculate_total_cost():
	@warning_ignore("narrowing_conversion")
	total_cost = base_cost + (current_upgrade_count) * cost_linear_multiplier \
			+ pow(cost_exponential_base, (current_upgrade_count))


func calculate_total_amount():
	total_amount = base_amount + current_upgrade_count * percent_amount_change * base_amount \
			+ flat_amount_change * current_upgrade_count


func update_upgrade():
	upgrade_button.text = str(upgrade_name, "\n Upgrade: ", total_cost, "g")
	if upgrade_cap > 0:
		upgrade_count_label.text = str(current_upgrade_count, "/", upgrade_cap)
	else:
		upgrade_count_label.text = str(current_upgrade_count)


func set_affordable(affordable: bool) -> void:
	upgrade_button.disabled = affordable
	if current_upgrade_count == upgrade_cap:
		upgrade_button.disabled = true


func _on_upgrade_button_pressed() -> void:
	Events.purchase_upgrade(upgrade_name, total_amount, total_cost)
	if upgrade_cap > 0 && current_upgrade_count < upgrade_cap:
		current_upgrade_count += 1
	elif upgrade_cap <= 0:
		current_upgrade_count += 1
