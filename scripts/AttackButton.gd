extends Button

onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")
onready var selection_manager = $"../../SelectionManager"

func _on_slash_attack_pressed():
	attack_template.click_mode = attack_template.MODE.SLASH
	selection_manager.selected.get_node("Char").preview_attack(attack_template.click_mode)
	