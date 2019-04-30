extends Label

onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mode = attack_template.get_click_mode()
	if mode == null:
		text = "Move"
	elif mode == attack_template.MODE.SLASH:
		text = "Slash"
	elif mode == attack_template.MODE.SWING:
		text = "Swing"
	elif mode == attack_template.MODE.LUNGE:
		text = "Lunge"
	else:
		mode == "Error"
		print_debug("Command Label does not recognise state")