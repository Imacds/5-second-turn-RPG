extends Button

onready var turn_manager = get_tree().get_root().get_node("Root/TurnManager")

func _on_TurnButton_pressed():
	turn_manager.end_turn()
