class_name Tunnel
extends Node2D

const ROCK_HORIZONTAL_SPACING := 162
const TUNNEL_VERTICAL_POSITION := 250
const NUMBER_OF_ROCKS := 10
const ROCK_HP_SCALING := 1
const RARE_ORE_PROBABILITY := 0.1

@export var rock_scene: PackedScene

var rocks: Array[Rock]
var next_rock_horizontal_position := 400
var next_rock_health := 5
var stats: Stats

@onready var dwarf: Dwarf = %Dwarf


func _ready() -> void:
	for i in NUMBER_OF_ROCKS:
		_spawn_new_rock()

	dwarf.base_damage = stats.base_damage
	dwarf.dash_duration = stats.dash_duration
	dwarf.pet_base_damge = stats.pet_base_damage


func _on_rock_destroyed() -> void:
	rocks.pop_front()
	_spawn_new_rock()
	dwarf.dash(ROCK_HORIZONTAL_SPACING)


func _spawn_new_rock() -> void:
	var rock: Rock = rock_scene.instantiate()
	rock.max_hp = next_rock_health
	rock.position = Vector2(next_rock_horizontal_position, TUNNEL_VERTICAL_POSITION)
	rock.destroyed.connect(_on_rock_destroyed)
	if randf() < RARE_ORE_PROBABILITY:
		rock.is_rare = true
	add_child(rock)
	rocks.append(rock)

	next_rock_horizontal_position += ROCK_HORIZONTAL_SPACING
	next_rock_health += ROCK_HP_SCALING


func _on_dwarf_mined(damage: int, is_crit: bool) -> void:
	rocks[0].mine(damage, is_crit)
