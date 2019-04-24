extends "res://scripts/AgentActionSystem/Action.gd"

var agent
var direction_str
var attack_template
var attack_mode
var execution_cost

func _init(agent, direction_str, attack_template, attack_mode, execution_cost = 1):
	self.attack_template = attack_template
	self.agent = agent
	self.direction_str = direction_str
	self.execution_cost = execution_cost
	
# override
func execute():
	attack_template.do_attack(
		agent.get_cell_coords(), 
		agent.attack_mode, 
		direction_str, 
		agent
	) # position, attack_mode, attack_dir, owner 
	
# override
func get_cost():
	return execution_cost