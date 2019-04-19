extends Button

onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")
onready var selection_manager = get_tree().get_root().get_node("Root/SelectionManager")
onready var attack_map  = get_tree().get_root().get_node("Root/AttackMap")


func _on_Undo_pressed():
	selection_manager.selected.get_node("Char").attack_mode = null
	selection_manager.selected.get_node("Char").attack_dir = Vector2()
	attack_template.click_mode = null
	attack_map.clear()
