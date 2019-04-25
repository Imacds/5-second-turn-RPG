extends "res://scripts/AgentActionSystem/Action.gd"

var execution_cost

func _init(execution_cost = 0):
	self.execution_cost = execution_cost
	
# override
func execute():
	return
	
# override
func get_cost():
	return execution_cost