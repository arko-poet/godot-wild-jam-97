class_name Rock
extends Node2D

signal destroyed

const RARE_ORE_DROP_COUNT := 5
const MAX_GEM_DROP_DISTANCE := Vector2i(64.0, 16.0)

@export var floating_text_scene: PackedScene

var max_hp := 5
var hp: int:
	set(value):
		hp = max(0, value)

		hp_bar.value = hp
		hp_label.text = "%s/%s" % [hp, max_hp]

		if hp == 0:
			_spawn_gems()
			Events.increase_depth()
			destroyed.emit()
			ore_break.show()
			ore_sprite.hide()
			ore_break.play()
var is_rare := false
var rock_resource: RockResource

@onready var hp_bar: ProgressBar = %HPBar
@onready var hp_label: Label = %HPLabel

@onready var ore_sprite: Sprite2D = %OreSprite
@onready var shadow_sprite: Sprite2D = %ShadowSprite
@onready var ore_break: AnimatedSprite2D = %OreBreak


func _ready() -> void:
	hp = max_hp
	hp_bar.max_value = max_hp

	if not rock_resource:
		push_error("no rock resource set")
	ore_sprite.texture = rock_resource.texture


func mine(damage: int, is_crit: bool) -> void:
	_hit_flash()
	_hit_shake()

	var floating_text: FloatingText = floating_text_scene.instantiate()
	if is_crit:
		floating_text.text_color = Color.YELLOW
	floating_text.text = str(damage)
	floating_text.position = position
	get_parent().add_child(floating_text)

	hp -= damage


func _spawn_gems() -> void:
	if is_rare:
		for i in RARE_ORE_DROP_COUNT:
			var horizontal_position_variation := Vector2(
				randf_range(0.0, MAX_GEM_DROP_DISTANCE.x),
				randf_range(0.0, MAX_GEM_DROP_DISTANCE.y),
			)
			Events.drop_gem(
				rock_resource.ore_resource,
				global_position + horizontal_position_variation,
			)
	else:
		Events.drop_gem(rock_resource.ore_resource, global_position)


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


func _hit_shake() -> void:
	var t: Tween = create_tween()
	t.tween_property(ore_sprite, ^"position:x", -1.0, 0.03)
	t.tween_property(ore_sprite, ^"position:x", 2.0, 0.06)
	t.tween_property(ore_sprite, ^"position:x", 0.0, 0.03)


func _on_ore_break_animation_finished() -> void:
	queue_free()
