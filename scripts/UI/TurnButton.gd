extends Button

onready var turn_manager = get_tree().get_root().get_node("Root/TurnManager")
onready var parent = get_parent().get_parent().get_parent()

func _on_TurnButton_pressed():
	if parent.enabled:
		turn_manager.end_turn()

func _unhandled_input(event):
	if parent.enabled:
		if Input.is_action_just_pressed("end_turn"):
			turn_manager.end_turn()