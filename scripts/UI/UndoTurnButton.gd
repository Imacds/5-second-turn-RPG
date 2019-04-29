extends Button

onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")
onready var selection_manager = get_tree().get_root().get_node("Root/SelectionManager")
onready var attack_map  = get_tree().get_root().get_node("Root/AttackMap")


func _on_Undo_pressed():
	if selection_manager.get_click_mode != null:
		attack_template.set_click_mode(null)
		attack_map.clear()
	else:
		selection_manager.selected.get_node("Char").undo_last_action()
	
