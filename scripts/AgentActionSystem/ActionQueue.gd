extends Node

signal finished_executing_actions(agent_name)

var max_size
var queue = []
var finished_current_action = false

func _init(max_queue_size = 3):
	max_size = max_queue_size

	
func push(action):
	if len(queue) >= max_size:
		print_debug("error: attempted to push more actions than ActionQueue can hold")
		return
	
	queue.append(action)

	
func execute_all(wait_time_between_actions = 0.15):
	$Timer.set_wait_time(wait_time_between_actions)
	$Timer.start()


func _on_Timer_timeout():
	if not queue.empty(): # more to execute
		print("begin exec")
		
		
#		await to_signal($"../Char", "single_action_finished")
#		yield(queue[0].execute(), "completed")
#		while not finished_current_action: # wait for signal that indicates action is completed
#			print("waiting for action to complete")
		queue[0].execute()
		finished_current_action = false
		queue.pop_front()
		$Timer.start()
	else:
		$Timer.stop()
		emit_signal("finished_executing_actions", get_parent().get_name())


func _on_Char_single_action_finished(action_name):
	finished_current_action = true
