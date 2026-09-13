extends Node

@export var _tunnel_scene: PackedScene

var _current_tunnel: Tunnel
var _gems: int:
	set(value):
		_gems = value
		_gems_label.text = "Gems: %s" % _gems

@onready var _doom_timer: Timer = %DoomTimer

@onready var _world: Node2D = %World

@onready var _doom_timer_label: Label = %DoomTimerLabel
@onready var _gems_label: Label = %GemsLabel
@onready var _start_button: Button = %StartButton


func _ready() -> void:
	Events.gem_collected.connect(_on_gem_collected)


func _process(_delta: float) -> void:
	_doom_timer_label.text = "Doom in: %.1fs" % _doom_timer.time_left


func _start_doom_timer() -> void:
	set_process(true)
	_doom_timer.start()


func _on_doom_timer_timeout() -> void:
	_start_button.disabled = false
	_current_tunnel.queue_free()
	set_process(false)


func _on_start_button_pressed() -> void:
	_start_button.disabled = true
	_start_doom_timer()
	_new_tunnel()


func _new_tunnel() -> void:
	_current_tunnel = _tunnel_scene.instantiate()
	_world.add_child(_current_tunnel)


func _on_gem_collected() -> void:
	_gems += 1
