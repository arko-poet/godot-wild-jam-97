extends Node
#
@export var _tunnel_scene: PackedScene

var _current_tunnel: Tunnel
@onready var _doom_timer: Timer = %DoomTimer

@onready var _world: Node2D = %World

@onready var _doom_timer_label: Label = %DoomTimerLabel
@onready var _start_button: Button = %StartButton

@onready var ui : Control = %UI
@onready var upgrades_menu : UpgradesMenu = %UpgradesMenu
@export var drop_resource : PackedScene


func _ready() -> void:
	
	@warning_ignore("unused_parameter")
	Events.resource_collected.connect(
		func on_resource_collected(resource_id, amount, drop_global_position):
			var drop_instance = drop_resource.instantiate()
			var camera = get_viewport().get_camera_2d()
			var offset = Vector2(16,16)
			var ui_target = upgrades_menu.resource_counters.get_child(resource_id)#resource_id

			##calculation is scene independent, just need to use camera position and ui target's global rect
			##this may break if we set aspect to expand.
			drop_instance.position = camera.to_local(drop_global_position) + get_viewport().get_visible_rect().size / 2.0
			ui.add_child(drop_instance)
			var tween = drop_instance.create_tween()
			tween.tween_property(drop_instance, "position", ui_target.get_global_rect().position + offset, 0.5).\
			set_trans(Tween.TRANS_QUAD)
			tween.tween_interval(0.1)
			tween.finished.connect(drop_instance.queue_free)

	)


func _process(_delta: float) -> void:
	_doom_timer_label.text = "Doom in: %.1fs" % _doom_timer.time_left


func _start_doom_timer() -> void:
	set_process(true)
	_doom_timer.start()

	upgrades_menu.toggle_button.disabled = true
	upgrades_menu.toggle_button.button_pressed = false
	upgrades_menu.hide_menu()


func _on_doom_timer_timeout() -> void:
	_start_button.disabled = false
	_current_tunnel.queue_free()
	set_process(false)

	upgrades_menu.toggle_button.disabled = false
	upgrades_menu.toggle_button.button_pressed = true
	upgrades_menu.show_menu()


func _on_start_button_pressed() -> void:
	_start_button.disabled = true
	_start_doom_timer()
	_new_tunnel()


func _new_tunnel() -> void:
	_current_tunnel = _tunnel_scene.instantiate()
	_world.add_child(_current_tunnel)
