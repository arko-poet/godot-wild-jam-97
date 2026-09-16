class_name Dwarf
extends CharacterBody2D

signal mined(damage: int, is_crit: bool)
signal mining_animation_finished

enum State {
	IDLE,
	DASHING,
	MINING,
}

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

var stats: Stats:
	set(value):
		stats = value

		base_damage = stats.base_damage
		increased_damage = stats.increased_damge
		pickaxe = stats.pickaxe
		auto_attack = stats.auto_attack
		crit_chance = stats.crit_chance
		crit_damage = stats.crit_damage
		attack_duration = stats.attack_duration

		dash_duration = stats.dash_duration

		pet_unlocked = stats.pet_unlocked
		pet_base_damage = stats.pet_base_damage
		pet_increased_damage = stats.pet_increased_damage
		pet_crit_chance = stats.pet_crit_chance
		pet_crit_damage = stats.pet_crit_damage
		pet.mining_timer.wait_time = stats.pet_attack_duration
var dash_duration := 0.5
var base_damage := 1
var increased_damage := 0.1
var damage_multiplier := 1
var pet_base_damage := 1
var pet_increased_damage := 0.0
var pet_crit_chance := 0.0
var pet_crit_damage := 0.0
var crit_chance := 0.0
var crit_damage := 2.0
var pickaxe := 0:
	set(value):
		pickaxe = value
		_upgrade_pickaxe()
var is_crit := false
var attack_duration := 1.0:
	set(value):
		attack_duration = value
		_update_animation_speed()
var auto_attack := false
var pet_unlocked := false

@onready var sprites: Array[AnimatedSprite2D] = [%Beard, %Pick, %Body]
@onready var state_label: Label = %StateLabel
@onready var pet: Pet = %Pet


func _ready() -> void:
	_update_animation_speed()

	sprites[0].modulate = Color.from_hsv(randf(), 1.0, 1.0)

	#_upgrade_pickaxe(pickaxe_upgrades[pickaxe], pickaxe + 1)
	#pet.mining_timer.wait_time = pet_attack_duration


func _process(_delta) -> void:
	if auto_attack and state == State.IDLE:
		_mine()


func _input(event: InputEvent) -> void:
	if state != State.IDLE:
		return

	if event.is_action(&"mine") and event.is_pressed() and not event.is_echo():
		get_viewport().set_input_as_handled()
		_mine()


func dash(distance: float) -> void:
	if state == State.MINING:
		await mining_animation_finished

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

	if pet_unlocked:
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

	if pet_unlocked:
		pet.start_mining()


func _mine() -> void:
	state = State.MINING

	# replace the following with animation
	for sprite in sprites:
		sprite.play(&"attack")

	is_crit = randf() <= crit_chance


func _on_pet_mined() -> void:
	if state == State.DASHING:
		return

	var damage := pet_base_damage * (1 + pet_increased_damage)
	var is_pet_crit := randf() <= pet_crit_chance
	if is_pet_crit:
		damage *= pet_crit_damage
	mined.emit(damage, is_pet_crit)


# body signal affects pick and beard as well
func _on_body_animation_finished() -> void:
	if state == State.MINING:
		state = State.IDLE
		for sprite in sprites:
			sprite.play(&"idle")
		mining_animation_finished.emit()


func _on_pick_frame_changed() -> void:
	if state == State.MINING and sprites[1].frame == 1:
		var sparks_attack: AnimatedSprite2D = sparks_attack_scene.instantiate()
		sparks_attack.position = position
		get_parent().add_child(sparks_attack)

		if is_crit:
			SfxController.play(pickaxe_crit_sfx)
		else:
			SfxController.play(pickaxe_sfx)

		var damage := base_damage * damage_multiplier * (1 + increased_damage)
		if is_crit:
			damage = int(damage * crit_damage)
		mined.emit(damage, is_crit)


func _update_animation_speed() -> void:
	for sprite in sprites:
		var dash_frame_count := sprite.sprite_frames.get_frame_count(&"dash")
		sprite.sprite_frames.set_animation_speed(&"dash", dash_frame_count / dash_duration)

		var attack_frame_count := sprite.sprite_frames.get_frame_count(&"attack")
		sprite.sprite_frames.set_animation_speed(&"attack", attack_frame_count / attack_duration)
