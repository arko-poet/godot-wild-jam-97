class_name Tunnel
extends Node2D

const ROCK_HORIZONTAL_SPACING := 128
const TUNNEL_VERTICAL_POSITION := 350
const NUMBER_OF_ROCKS := 10

@export var rock_scene: PackedScene

var rocks: Array[Rock]
var next_rock_horizontal_position := 600


func _ready() -> void:
	for i in NUMBER_OF_ROCKS:
		_spawn_new_rock()


func _on_rock_destroyed() -> void:
	rocks.pop_front()
	_spawn_new_rock()
	
	
func _spawn_new_rock() -> void:
	var rock: Rock = rock_scene.instantiate()
	rock.position = Vector2(next_rock_horizontal_position, TUNNEL_VERTICAL_POSITION)
	rock.destroyed.connect(_on_rock_destroyed)
	add_child(rock)
	next_rock_horizontal_position += ROCK_HORIZONTAL_SPACING
