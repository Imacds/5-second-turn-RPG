extends RichTextLabel

onready var selection_manager = get_tree().get_root().get_node("Root/SelectionManager")
onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")

var MoveAction = load("res://scripts/AgentActionSystem/MoveAction.gd")
var AttackAction = load("res://scripts/AgentActionSystem/AttackAction.gd")
var WaitAction = load("res://scripts/AgentActionSystem/WaitAction.gd")

func _process(delta):
	var queue = selection_manager.selected.get_node("Char").get_node("ActionQueue").get_queue()
	var actions = []
	for object in queue:
		if object is WaitAction:
			continue
		else:
			var mode_str = ""	
			if object is AttackAction:
				var mode = object.attack_mode
				if mode == attack_template.MODE.SLASH:
					mode_str = "Slash"
				elif mode == attack_template.MODE.SWING:
					mode_str = "Swing"
				elif mode == attack_template.MODE.LUNGE:
					mode_str = "Lunge"
				else:
					mode_str == "Error"
					print_debug("Queue List does not recognise state")
				mode_str += " " + object.direction_str
			elif object is MoveAction:
				mode_str = "Move"
				var dir = object.direction 
				if dir == Vector2(1,0):
					mode_str += " right"
				elif dir == Vector2(-1,0):
					mode_str += " left"
				elif dir == Vector2(0,1):
					mode_str += " down"
				elif dir == Vector2(0,-1):
					mode_str += " up"
				else:
					mode_str == "Error"
					print_debug("Queue List does not recognise direction")
			actions.append(mode_str)
	
	text = "Queue List"
	text += "\n\n1. " + actions[0] if len(actions) >= 1 else ""
	text += "\n\n2. " + actions[1] if len(actions) >= 2 else ""
	text += "\n\n3. " + actions[2] if len(actions) >= 3 else ""