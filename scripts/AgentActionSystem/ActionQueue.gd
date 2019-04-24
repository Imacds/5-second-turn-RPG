extends Node

signal begin_executing_actions(agent_name)
signal finished_executing_actions(agent_name)

var max_size
var queue = []

onready var parent_name = get_parent().get_name()

func _init(max_queue_size = 3):
	max_size = max_queue_size

	
func push(action):
	if len(queue) >= max_size:
		print_debug("error: attempted to push more actions than ActionQueue can hold")
		return false
	
	queue.append(action)
	return true


func execute_all(wait_time_between_actions = 0.15):
	emit_signal("begin_executing_actions", parent_name)
	$Timer.set_wait_time(wait_time_between_actions)
	$Timer.start()


func _on_Timer_timeout():
	if not queue.empty(): # more to execute
		queue[0].execute()
		queue.pop_front()
		$Timer.start()
	else:
		$Timer.stop()
		emit_signal("finished_executing_actions", parent_name)
