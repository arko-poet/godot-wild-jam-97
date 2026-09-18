class_name Gem
extends Node2D

var ore_resource: OreResource

@onready var sprite: Sprite2D = %Sprite


func _ready() -> void:
	if ore_resource:
		sprite.texture = ore_resource.texture
	else:
		push_error("Missing Ore Resource")
