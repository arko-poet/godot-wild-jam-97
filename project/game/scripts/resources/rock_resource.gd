class_name RockResource
extends Resource

enum Type {
	BASIC,
	CRYSTAL,
	EMERALD,
	RUBY,
	SAPPHIRE,
}

@export var type: Type
@export var texture: Texture2D
@export var spawn_weight: int
@export var minimum_depth: int
