class_name Tunnel
extends Node2D

const ROCK_HORIZONTAL_SPACING := 162
const TUNNEL_VERTICAL_POSITION := 250
const NUMBER_OF_ROCKS := 10
const ROCK_HP_SCALING := 1
const BACKGROUND_FILTER_HUE_CHANGE := -0.02
@export var floating_text_scene: PackedScene

@export var rock_scene: PackedScene
@export var basic_rock_resource: RockResource
@export var rare_rock_resources: Array[RockResource]

var rocks: Array[Rock]
var next_rock_horizontal_position := 400
var next_rock_health := 10
var stats: Stats
var background_filter_hue := 1.0:
	set(value):
		background_filter_hue = value
		background_filter.modulate = Color.from_hsv(background_filter_hue, 1.0, 1.0)
var rare_ore_probability := 0.05

var trauma: float:
	set(value):
		trauma = min(1.0, max(value, 0.0))
var decay := 1.0

var _rocks_spawned: int

@onready var dwarf: Dwarf = %Dwarf
@onready var background_filter: Sprite2D = %BackgroundFilter


func _ready() -> void:
	rare_ore_probability += stats.ore_rarity

	for i in NUMBER_OF_ROCKS:
		_spawn_new_rock()

	dwarf.stats = stats

	background_filter_hue = background_filter_hue

	#dwarf.camera.zoom = Vector2(1.05, 1.05)


func _process(delta: float) -> void:
	trauma = max(trauma - decay * delta, 0.0)
	shake()

func shake() -> void:
	var shake_scale = PlayerConfig.get_config(AppSettings.VIDEO_SECTION, "CameraShake", 1.0)
	var camera := dwarf.camera
	#rotation = 1 * trauma * randf_range(-1, 1)
	camera.offset.x = shake_scale * 2 * trauma * randf_range(-1, 1)
	camera.offset.y = shake_scale * 2 * trauma * randf_range(-1, 1)
	#camera.zoom = 1.1 * amount


func show_hp_regen(hp: int, regen: bool) -> void:
	var floating_text: FloatingText = floating_text_scene.instantiate()

	if regen:
		floating_text.text_color = Color.WEB_GREEN
		floating_text.font_size = 8
	else:
		floating_text.text_color = Color.LAWN_GREEN

	floating_text.text = "+%s" % hp
	floating_text.position = dwarf.position

	get_parent().add_child(floating_text)


func _on_rock_destroyed() -> void:
	rocks.pop_front()
	_spawn_new_rock()
	dwarf.dash(ROCK_HORIZONTAL_SPACING)

	background_filter_hue += BACKGROUND_FILTER_HUE_CHANGE

	trauma += 1.0


func _spawn_new_rock() -> void:
	var rock: Rock = rock_scene.instantiate()

	var rock_resource: RockResource
	if randf() < rare_ore_probability:
		rock.is_rare = true
		var spawn_weights: Dictionary[RockResource, int]
		for rare_resource in rare_rock_resources:
			if _rocks_spawned >= rare_resource.minimum_depth: # TODO replace with depth check
				spawn_weights[rare_resource] = rare_resource.spawn_weight
		var rng = RandomNumberGenerator.new()
		var index = rng.rand_weighted(spawn_weights.values())
		rock_resource = spawn_weights.keys()[index]
	else:
		rock_resource = basic_rock_resource

	rock.rock_resource = rock_resource
	rock.max_hp = next_rock_health
	rock.position = Vector2(next_rock_horizontal_position, TUNNEL_VERTICAL_POSITION)
	rock.destroyed.connect(_on_rock_destroyed)

	add_child(rock)
	rocks.append(rock)

	next_rock_horizontal_position += ROCK_HORIZONTAL_SPACING
	next_rock_health += ROCK_HP_SCALING

	_rocks_spawned += 1


func _on_dwarf_mined(damage: int, is_crit: bool, is_pet: bool) -> void:
	if _is_dwarf_next_to_rock():
		rocks[0].mine(damage, is_crit, is_pet)


func _is_dwarf_next_to_rock() -> bool:
	#if rocks.is_empty():
	#return false
	return dwarf.global_position.distance_to(rocks[0].global_position) <= ROCK_HORIZONTAL_SPACING
