extends RichTextLabel

onready var victory_menu = get_tree().get_root().get_node("Root/VictoryMenu")

func _process(delta):
	text = "Tasks:"
	
	if victory_menu.goal_kill():
		text += "\n\nKill " + victory_menu.num_kill() + " more enemies"
	
	if victory_menu.goal_movement():
		text += "\n\nMove to " + str(victory_menu.goal_pos)