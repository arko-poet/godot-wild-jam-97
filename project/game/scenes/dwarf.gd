class_name Dwarf
extends CharacterBody2D

var dash_duration := 1.0


#func _physics_process(_delta: float) -> void:
	#var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#velocity = direction * 400
	#move_and_slide()


func dash(distance: float) -> void:
	var tween = create_tween()
	tween.tween_property(self, ^"position:x", position.x + distance, dash_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
