extends Node

const _DEFAULT_HP_DRAIN := 0.1

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
var _max_hp := 10.0
var _hp: float:
	set(value):
		_hp = min(_max_hp, max(0.0, value))

		_hp_bar.value = _hp
		_hp_bar.max_value = _max_hp
		_hp_label.text = "HP: %.1f/%.1f" % [_hp, _max_hp]
		if _hp == 0:
			_on_hp_drained()

var _hp_drain := 0.1
var _hp_regen := 0.0

var _depth: int:
	set(value):
		_depth = value
		_depth_label.text = "Depth %s" % _depth

		_hp_drain = (1 + floor(_depth / 10)) * _DEFAULT_HP_DRAIN

@onready var pause_menu_controller: Node = %PauseMenuController

@onready var _hp_bar: ProgressBar = %HPBar
@onready var _hp_label: Label = %HPLabel
@onready var _ui: Control = %UI
@onready var _upgrades_menu: UpgradesMenu = %UpgradesMenu
@onready var _gems_texture: TextureRect = %GemsTexture
@onready var _hp_drain_timer: Timer = $HPDrainTimer

@onready var _gems_label: Label = %GemsLabel

@onready var _world: Node2D = %World

@onready var _start_button: Button = %StartButton
@onready var _depth_label: Label = %DepthLabel


func _ready() -> void:
	_stats = Stats.new()

	Events.gem_dropped.connect(_on_gem_dropped)
	Events.upgrade_purchased.connect(_on_upgrade_purchased)
	Events.depth_increased.connect(_on_depth_increased)

	_start_button.grab_focus()

	_hp = _max_hp


#func _process(_delta: float) -> void:
#_doom_timer_label.text = "Doom in: %.1fs" % _doom_timer.time_left
func _start_doom_timer() -> void:
	set_process(true)
	_hp_drain_timer.start()

	_upgrades_menu.hide_menu()


func _on_hp_drained() -> void:
	_depth_label.hide()
	_depth = 0
	_start_button.show()
	_hp_drain_timer.stop()
	_hp_bar.hide()
	_current_tunnel.queue_free()
	set_process(false)

	#if not _upgrades_menu.try_grab_focus(_gems):
	#_start_button.grab_focus()
	_upgrades_menu.show_menu()


func _on_start_button_pressed() -> void:
	_hp_bar.show()
	_start_button.hide()
	_start_doom_timer()
	_new_tunnel()


func _new_tunnel() -> void:
	_depth_label.show()

	_max_hp = _stats.hp
	_hp = _max_hp
	_hp_regen = _stats.hp_regen
	_hp_drain = _DEFAULT_HP_DRAIN

	_current_tunnel = _tunnel_scene.instantiate()
	_current_tunnel.stats = _stats
	_world.add_child(_current_tunnel)


func _on_gem_dropped(ore_resource: OreResource, global_position: Vector2):
	var gem: Gem = _gem_scene.instantiate()
	gem.ore_resource = ore_resource

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
	tween.finished.connect(_collect_gem.bind(gem, ore_resource.value))


func _collect_gem(gem: Node2D, amount: int) -> void:
	gem.queue_free()
	_gems += amount
	SfxController.play(_gem_sound)


func _on_upgrade_purchased(_upgrade_name: String, _amount: float, upgrade_cost: int) -> void:
	_gems -= upgrade_cost


func _on_options_button_pressed() -> void:
	pause_menu_controller.pause()


func _on_hp_drain_timer_timeout() -> void:
	_hp -= _hp_drain
	_hp += _hp_regen


func _on_depth_increased() -> void:
	_depth += 1
