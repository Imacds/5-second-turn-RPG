extends Node

var max_size
var queue = []


func _init(max_queue_size = 3):
	max_size = max_queue_size

	
func push(action):
	if len(queue) >= max_size:
		print_debug("error: attempted to push more actions than ActionQueue can hold")
		return
	
	queue.append(action)

	
func execute_all():
	for action in queue:
		action.execute()