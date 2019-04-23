extends "res://scripts/AgentActionSystem/Action.gd"

var options
var scene_root

func _init(options_param = [], scene_root_param = null):
	options = options_param
	scene_root = scene_root_param
	
# override
# param options[0]: Player instance
# param options[1]: Direction Vector2
func execute():
	var agent = options[0] # get agent (Player.gd instance)
	var direction = options[1] # direction vector with magitude of 1
	agent.move_one_cell(direction)