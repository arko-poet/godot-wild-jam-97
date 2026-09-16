extends Node

@export var _gem_scene: PackedScene
@export var _tunnel_scene: PackedScene

@export var _gem_sound: AudioStream

var _current_tunnel: Tunnel
var _stats: Stats
var _gems: int:
	set(value):
		_gems = value
		_gems_label.text = ": %s" % _gems
		_upgrades_menu.gems_changed(_gems)

@onready var _ui: Control = %UI
@onready var _upgrades_menu: UpgradesMenu = %UpgradesMenu
@onready var _gems_texture: TextureRect = %GemsTexture
@onready var _doom_timer: Timer = %DoomTimer
@onready var _gems_label: Label = %GemsLabel

@onready var _world: Node2D = %World

@onready var _doom_timer_label: Label = %DoomTimerLabel
@onready var _start_button: Button = %StartButton


func _ready() -> void:
	_stats = Stats.new()

	Events.gem_dropped.connect(_on_gem_dropped)
	Events.upgrade_purchased.connect(_on_upgrade_purchased)


func _process(_delta: float) -> void:
	_doom_timer_label.text = "Doom in: %.1fs" % _doom_timer.time_left


func _start_doom_timer() -> void:
	set_process(true)
	_doom_timer.start(_stats.doom_time)

	_upgrades_menu.hide_menu()


func _on_doom_timer_timeout() -> void:
	_start_button.show()
	_doom_timer_label.hide()
	_current_tunnel.queue_free()
	set_process(false)

	_upgrades_menu.show_menu()


func _on_start_button_pressed() -> void:
	_doom_timer_label.show()
	_start_button.hide()
	_start_doom_timer()
	_new_tunnel()


func _new_tunnel() -> void:
	_current_tunnel = _tunnel_scene.instantiate()
	_current_tunnel.stats = _stats
	_world.add_child(_current_tunnel)


func _on_gem_dropped(_gem_id: int, amount: int, global_position: Vector2):
	var gem = _gem_scene.instantiate()
	var camera = get_viewport().get_camera_2d()

	# calculation is scene independent, just need to use camera position and ui target's global rect
	# this may break if we set aspect to expand.
	gem.position = camera.to_local(global_position) + get_viewport().get_visible_rect().size / 2.0
	_ui.add_child(gem)
	var tween = create_tween()
	var duration_variation := randf_range(0.0, 0.3)
	tween.tween_property(gem, ^"position", _gems_texture.position, 0.5 + duration_variation) \
			.set_trans(Tween.TRANS_CUBIC) \
			.set_ease(Tween.EASE_IN)
	tween.finished.connect(_collect_gem.bind(gem, amount))


func _collect_gem(gem: Node2D, amount: int) -> void:
	gem.queue_free()
	_gems += amount
	SfxController.play(_gem_sound)


func _on_upgrade_purchased(_upgrade_name: String, _amount: float, upgrade_cost: int) -> void:
	_gems -= upgrade_cost
