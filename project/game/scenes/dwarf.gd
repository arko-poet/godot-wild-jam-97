class_name Dwarf
extends CharacterBody2D

signal mined(damage: int)

enum State {
	IDLE,
	DASHING,
	MINING,
}

const MINING_DURATION := 0.3

var state := State.IDLE:
	set(value):
		state = value
		state_label.text = State.keys()[state]

var dash_duration := 0.5
var base_damage := 1
var pet_base_damge := 1

@onready var sprites: Array[AnimatedSprite2D] = [%Beard, %Pick, %Body]
@onready var state_label: Label = %StateLabel
@onready var pet: Pet = %Pet


func _ready() -> void:
	for sprite in sprites:
		var dash_frame_count := sprite.sprite_frames.get_frame_count(&"dash")
		sprite.sprite_frames.set_animation_speed(&"dash", dash_frame_count / dash_duration)

		var attack_frame_count := sprite.sprite_frames.get_frame_count(&"attack")
		sprite.sprite_frames.set_animation_speed(&"attack", attack_frame_count / MINING_DURATION)


#func _physics_process(_delta: float) -> void:
#var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
#velocity = direction * 400
#move_and_slide()
func _input(event: InputEvent) -> void:
	if state != State.IDLE:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
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

	pet.stop_mining()


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


func _on_pet_mined() -> void:
	if state == State.DASHING:
		return

	mined.emit(pet_base_damge)


# body signal affects pick and beard as well
func _on_body_animation_finished() -> void:
	if state == State.MINING:
		state = State.IDLE
		for sprite in sprites:
			sprite.play(&"idle")
		mined.emit(base_damage)
