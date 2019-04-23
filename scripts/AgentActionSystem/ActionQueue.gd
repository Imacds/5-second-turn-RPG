extends Node

signal finished_executing_actions(agent_name)

var max_size
var queue = []

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
		queue[0].execute()
		queue.pop_front()
		$Timer.start()
	else:
		$Timer.stop()
		emit_signal("finished_executing_actions", get_parent().get_name())


func _on_Char_single_action_finished(action_name):
	pass
