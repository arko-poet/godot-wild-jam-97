class_name Dwarf
extends CharacterBody2D

signal mined(damage: int, is_crit: bool)

enum State {
	IDLE,
	DASHING,
	MINING,
}

const MINING_DURATION := 0.3

@export var sparks_attack_scene: PackedScene
@export var smoke_dash_scene: PackedScene
@export var pickaxe_upgrades: Array[SpriteFrames]

@export_group("Sfx")
@export var dash_sfx: AudioStream
@export var pickaxe_sfx: AudioStream
@export var pickaxe_crit_sfx: AudioStream

var state := State.IDLE:
	set(value):
		state = value
		state_label.text = State.keys()[state]

var dash_duration := 0.5
var base_damage := 1
var damage_multiplier := 1
var pet_base_damge := 1
var crit_chance := 0.2
var crit_multiplier := 2.0
var pickaxe := 0:
	set(value):
		pickaxe = value
		_upgrade_pickaxe()
var is_crit := false

@onready var sprites: Array[AnimatedSprite2D] = [%Beard, %Pick, %Body]
@onready var state_label: Label = %StateLabel
@onready var pet: Pet = %Pet


func _ready() -> void:
	_update_animation_speed()

	sprites[0].modulate = Color.from_hsv(randf(), 1.0, 1.0)

	#_upgrade_pickaxe(pickaxe_upgrades[pickaxe], pickaxe + 1)


func _input(event: InputEvent) -> void:
	if state != State.IDLE:
		return

	if event.is_action(&"mine") and event.is_pressed() and not event.is_echo():
		get_viewport().set_input_as_handled()
		_mine()


func dash(distance: float) -> void:
	state = State.DASHING

	var tween = create_tween()
	tween.finished.connect(_on_dash_finsished)
	tween \
			.tween_property(self, ^"position:x", position.x + distance, dash_duration) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_OUT)

	for sprite in sprites:
		sprite.play(&"dash")

	var smoke_dash: AnimatedSprite2D = smoke_dash_scene.instantiate()
	smoke_dash.dash_duration = dash_duration
	add_child(smoke_dash)

	pet.stop_mining()

	SfxController.play(dash_sfx)


func _upgrade_pickaxe() -> void:
	sprites[1].sprite_frames = pickaxe_upgrades[pickaxe]

	damage_multiplier = pickaxe + 1

	_update_animation_speed()

	#sprites[1].frame_changed.connect(_on_pick_frame_changed)


func _on_dash_finsished() -> void:
	if state != State.DASHING:
		return

	state = State.IDLE
	for sprite in sprites:
		sprite.play(&"idle")

	pet.start_mining()


func _mine() -> void:
	state = State.MINING

	# replace the following with animation
	for sprite in sprites:
		sprite.play(&"attack")

	is_crit = randf() < crit_chance


func _on_pet_mined() -> void:
	if state == State.DASHING:
		return

	mined.emit(pet_base_damge, false)


# body signal affects pick and beard as well
func _on_body_animation_finished() -> void:
	if state == State.MINING:
		state = State.IDLE
		for sprite in sprites:
			sprite.play(&"idle")

		var damage := base_damage * damage_multiplier
		if is_crit:
			damage = int(damage * crit_multiplier)
		mined.emit(damage, is_crit)


func _on_pick_frame_changed() -> void:
	if state == State.MINING and sprites[1].frame == 1:
		var sparks_attack: AnimatedSprite2D = sparks_attack_scene.instantiate()
		sparks_attack.position = position
		get_parent().add_child(sparks_attack)

		if is_crit:
			SfxController.play(pickaxe_crit_sfx)
		else:
			SfxController.play(pickaxe_sfx)


func _update_animation_speed() -> void:
	for sprite in sprites:
		var dash_frame_count := sprite.sprite_frames.get_frame_count(&"dash")
		sprite.sprite_frames.set_animation_speed(&"dash", dash_frame_count / dash_duration)

		var attack_frame_count := sprite.sprite_frames.get_frame_count(&"attack")
		sprite.sprite_frames.set_animation_speed(&"attack", attack_frame_count / MINING_DURATION)
