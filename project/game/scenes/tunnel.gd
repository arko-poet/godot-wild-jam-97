class_name Tunnel
extends Node2D

const ROCK_HORIZONTAL_SPACING := 162
const TUNNEL_VERTICAL_POSITION := 250
const NUMBER_OF_ROCKS := 10
const ROCK_HP_SCALING := 1
const RARE_ORE_PROBABILITY := 0.25
const BACKGROUND_FILTER_HUE_CHANGE := -0.02

@export var rock_scene: PackedScene
@export var basic_rock_resource: RockResource
@export var rare_rock_resources: Array[RockResource]

var rocks: Array[Rock]
var next_rock_horizontal_position := 400
var next_rock_health := 5
var stats: Stats
var background_filter_hue := 1.0:
	set(value):
		background_filter_hue = value
		background_filter.modulate = Color.from_hsv(background_filter_hue, 1.0, 1.0)

@onready var dwarf: Dwarf = %Dwarf
@onready var background_filter: Sprite2D = %BackgroundFilter


func _ready() -> void:
	for i in NUMBER_OF_ROCKS:
		_spawn_new_rock()

	dwarf.stats = stats
	if dwarf.pet_unlocked:
		dwarf.pet.start_mining()

	background_filter_hue = background_filter_hue


func _on_rock_destroyed() -> void:
	rocks.pop_front()
	_spawn_new_rock()
	dwarf.dash(ROCK_HORIZONTAL_SPACING)

	background_filter_hue += BACKGROUND_FILTER_HUE_CHANGE


func _spawn_new_rock() -> void:
	var rock: Rock = rock_scene.instantiate()

	var rock_resource: RockResource
	if randf() < RARE_ORE_PROBABILITY:
		rock.is_rare = true
		var spawn_weights: Dictionary[RockResource, int]
		for rare_resource in rare_rock_resources:
			if true: # TODO replace with depth check
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


func _on_dwarf_mined(damage: int, is_crit: bool) -> void:
	rocks[0].mine(damage, is_crit)
