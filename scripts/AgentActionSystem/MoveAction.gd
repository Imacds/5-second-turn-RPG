extends "res://scripts/AgentActionSystem/Action.gd"

# override
func execute(scene_root, options = []):
	var agent = options[0] # get agent (Player.gd instance)
	var direction = options[1] # direction vector with magitude of 1
	agent.move_one_cell(direction)