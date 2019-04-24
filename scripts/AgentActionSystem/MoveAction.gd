extends "res://scripts/AgentActionSystem/Action.gd"

var options
var scene_root
var execution_cost

func _init(options_param = [], scene_root_param = null, execution_cost = 1):
	options = options_param
	scene_root = scene_root_param
	self.execution_cost = execution_cost
	
# override
# param options[0]: Player instance
# param options[1]: Direction Vector2
func execute():
	var agent = options[0] # get agent (Player.gd instance)
	var direction = options[1] # direction vector with magitude of 1
	agent.move_one_cell(direction)
	
func get_cost():
	return execution_cost