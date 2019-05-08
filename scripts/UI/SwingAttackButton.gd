extends Button

onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")
onready var parent = get_parent().get_parent().get_parent()

func _on_SwingAttackButton_pressed():
	if parent.enabled:
		attack_template.set_click_mode(attack_template.MODE.SWING)

func _unhandled_input(event):
	if parent.enabled:
		if Input.is_action_just_pressed("attack2"):
			attack_template.set_click_mode(attack_template.MODE.SWING)