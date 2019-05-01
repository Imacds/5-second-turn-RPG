extends Button

onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")


func _on_SlashAttackButton_pressed():
	attack_template.set_click_mode(attack_template.MODE.SLASH)

func _unhandled_input(event):
	if Input.is_action_just_pressed("attack1"):
		attack_template.set_click_mode(attack_template.MODE.SLASH)