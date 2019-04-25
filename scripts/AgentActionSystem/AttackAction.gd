extends "res://scripts/AgentActionSystem/Action.gd"

var agent
var direction_str
var attack_template
var attack_mode
var execution_cost
var wait_time

var timer = null

func _init(agent, direction_str, attack_template, attack_mode, execution_cost = 1, wait_time_before_attack = 0.15):
	self.agent = agent
	self.direction_str = direction_str
	self.attack_template = attack_template
	self.attack_mode = attack_mode
	self.execution_cost = execution_cost
	self.wait_time = wait_time_before_attack
	
# override
func execute():
#	timer = Timer.new()
#	timer.connect("timerout", self, "_execute_attack")
#	timer.set_wait_time(0)
#	timer.set_one_shot(true)
#
#	add_child(timer)
#	timer.start()
	_execute_attack()
	
func _execute_attack():
	attack_template.do_attack(
		agent.get_cell_coords(), 
		attack_mode, 
		direction_str, 
		agent
	) # position, attack_mode, attack_dir, owner 
	
#	timer.queue_free()
	
# override
func get_cost():
	return execution_cost