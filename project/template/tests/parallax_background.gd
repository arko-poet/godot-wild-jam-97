@tool
extends Node2D

@export var scroll : Vector2 = Vector2.ZERO: ##adjust this value to scroll all 3 layers
    set(value):
        scroll = value
        update_offsets()
@export var layer1_ratio : float = 1.0 ##speed ratio which layer1 scrolls at
@export var layer2_ratio : float = 1.0 ##speed ratio which layer2 scrolls at
@export var layer3_ratio : float = 1.0 ##speed ratio which layer3 scrolls at

var mat1
var mat2
var mat3

func update_offsets():
    if mat1 != null:
        mat1.set_shader_parameter("offset", scroll * layer1_ratio)
    if mat2 != null:
        mat2.set_shader_parameter("offset", scroll * layer2_ratio)
    if mat3 != null:
        mat3.set_shader_parameter("offset", scroll * layer3_ratio)

func _ready() -> void:
    mat1 = get_node_or_null("Layer1").material
    mat2 = get_node_or_null("Layer2").material
    mat3 = get_node_or_null("Layer3").material
    
