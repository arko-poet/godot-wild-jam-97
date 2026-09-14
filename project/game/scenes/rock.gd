class_name Rock
extends Node2D

signal destroyed

@export var gem_scene: PackedScene

var max_hp := 3
var hp: int:
	set(value):
		hp = max(0, value)
		
		hp_bar.value = hp
		hp_label.text = "%s/%s" % [hp, max_hp]
		
		if hp == 0:
			_spawn_gems()
			destroyed.emit()
			queue_free()

@onready var hp_bar: ProgressBar = %HPBar
@onready var hp_label: Label = %HPLabel


func _ready() -> void:
	hp = max_hp
	hp_bar.max_value = max_hp


func mine(damage: int) -> void:
	hp -= damage


func _on_damage_button_pressed() -> void:
	mine(1)


func _spawn_gems() -> void:
	var gem: Gem = gem_scene.instantiate()
	gem.position = position
	get_parent().add_child(gem)

	Events.collect_resource(0, 1, global_position)