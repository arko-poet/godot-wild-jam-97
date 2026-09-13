extends Node

var current_tunnel: Tunnel

@export var tunnel_scene: PackedScene

@onready var _doom_timer: Timer = %DoomTimer

@onready var world: Node2D = %World

@onready var _doom_timer_label: Label = %DoomTimerLabel
@onready var _start_button: Button = %StartButton


func _process(_delta: float) -> void:
	_doom_timer_label.text = "Doom in: %.1fs" % _doom_timer.time_left


func _start_doom_timer() -> void:
	set_process(true)
	_doom_timer.start()


func _on_doom_timer_timeout() -> void:
	_start_button.disabled = false
	current_tunnel.queue_free()
	set_process(false)


func _on_start_button_pressed() -> void:
	_start_button.disabled = true
	_start_doom_timer()
	_new_tunnel()


func _new_tunnel() -> void:
	current_tunnel = tunnel_scene.instantiate()
	world.add_child(current_tunnel)
