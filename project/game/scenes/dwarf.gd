class_name Dwarf
extends CharacterBody2D

signal mined(damage: int)

enum State {
	IDLE,
	DASHING,
	MINING
}

var state := State.IDLE:
	set(value):
		state = value
		state_label.text = State.keys()[state]
		
var dash_duration := 0.5
var base_damage := 1
var pet_base_damge := 1


@onready var mining_timer: Timer = %MiningTimer
@onready var state_label: Label = %StateLabel
@onready var pet: Pet = %Pet


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
	tween.tween_property(self, ^"position:x", position.x + distance, dash_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	pet.stop_mining()


func _on_dash_finsished() -> void:
	if state != State.DASHING:
		return
		
	state = State.IDLE
	
	pet.start_mining()


func _mine() -> void:
	state = State.MINING
	
	# replace the following with animation
	mining_timer.start()


func _on_mining_timer_timeout() -> void:
	if state != State.MINING:
		return

	state = State.IDLE
	mined.emit(base_damage)


func _on_pet_mined() -> void:
	if state == State.DASHING:
		return
	
	mined.emit(pet_base_damge)
