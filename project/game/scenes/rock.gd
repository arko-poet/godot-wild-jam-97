class_name Rock
extends Node2D

signal destroyed

const RARE_ORE_DROP_COUNT := 10

@export var floating_text_scene: PackedScene
@export var rare_ore_texture: Texture2D

var max_hp := 5
var hp: int:
	set(value):
		hp = max(0, value)

		hp_bar.value = hp
		hp_label.text = "%s/%s" % [hp, max_hp]

		if hp == 0:
			_spawn_gems()
			destroyed.emit()
			queue_free()
var rare := false

@onready var hp_bar: ProgressBar = %HPBar
@onready var hp_label: Label = %HPLabel
@onready var ore_sprite: Sprite2D = %OreSprite
@onready var shadow_sprite: Sprite2D = %ShadowSprite


func _ready() -> void:
	hp = max_hp
	hp_bar.max_value = max_hp

	if rare:
		ore_sprite.texture = rare_ore_texture
		shadow_sprite.hide()


func mine(damage: int) -> void:
	_hit_flash()

	var floating_text: FloatingText = floating_text_scene.instantiate()
	floating_text.text = str(damage)
	floating_text.position = position
	get_parent().add_child(floating_text)

	hp -= damage


func _spawn_gems() -> void:
	if rare:
		for i in RARE_ORE_DROP_COUNT:
			Events.collect_resource(0, 1, global_position)
	else:
		Events.collect_resource(0, 1, global_position)


func _hit_flash() -> void:
	ore_sprite.material.set_shader_parameter("flash_amount", 1.0)
	var t: Tween = create_tween()
	t.tween_method(
		func(x):
			ore_sprite.material.set_shader_parameter("flash_amount", x),
		1,
		0,
		0.1,
	)
	t.play()
