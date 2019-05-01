extends Button

onready var selection_manager = get_tree().get_root().get_node("Root/SelectionManager")


func _on_ControlSwitch_pressed():
	selection_manager.toggle_control()

func _unhandled_input(event):
	if Input.is_action_just_pressed("switch_agent_control"):
		selection_manager.toggle_control()