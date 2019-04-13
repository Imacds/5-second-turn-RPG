extends Button

onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")
onready var selection_manager = get_tree().get_root().get_node("Root/SelectionManager")

func _on_undo_attack_pressed():
	if attack_template.click_mode != null:
		attack_template.click_mode = null
	else:
		selection_manager.selected.attack_mode = null
		selection_manager.selected.attack_dir = Vector2()