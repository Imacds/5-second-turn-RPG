extends "res://scripts/AgentActionSystem/Action.gd"

var agent
var direction
var execution_cost

func _init(agent, direction, execution_cost = 1):
	self.agent = agent
	self.direction = direction
	self.execution_cost = execution_cost
	
# override
func execute():
	agent.move_one_cell(direction)
	
# override
func get_cost():
	return execution_cost