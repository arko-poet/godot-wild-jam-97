extends Node2D

var max_hp := 10
var hp: int:
	set(value):
		hp = max(0, value)
		
		hp_bar.value = hp
		hp_label.text = "%s/%s" % [hp, max_hp]
		
		if hp == 0:
			queue_free()

@onready var hp_bar: ProgressBar = %HPBar
@onready var hp_label: Label = %HPLabel


func _ready() -> void:
	hp = max_hp
	hp_bar.max_value = max_hp


func mine(damage: int) -> void:
	hp -= damage
