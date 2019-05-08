extends Node

signal begin_executing_actions(agent_name)
signal finished_executing_actions(agent_name)

var max_size
var queue = []

onready var parent_name = get_parent().get_name()
onready var sounds = $"../CharSounds"

func _init(max_queue_size = 6):
	max_size = max_queue_size

	
func push(action):
	if len(queue) >= max_size:
		print_debug("error: attempted to push more actions than ActionQueue can hold")
		return false
	
	queue.append(action)
	return true

func peek_back():
	if len(queue) > 0:
		return queue[-1]
	else:
		return null

func pop_back():
	if len(queue) > 0:
		queue.pop_back()
	else:
		print_debug("error: attempted to pop an empty ActionQueue")

func execute_all(wait_time_between_actions = 0.15):
	emit_signal("begin_executing_actions", parent_name)
	$Timer.set_wait_time(wait_time_between_actions)
	$Timer.start()

func get_queue():
	return queue

func _on_Timer_timeout():
	if not queue.empty() and not $"../".is_dead(): # more to execute & agent is not dead
		queue[0].execute()
		sounds.play_corresponding_sound(queue[0])
		queue.pop_front()
		$Timer.start()
	else:
		$Timer.stop()
		emit_signal("finished_executing_actions", parent_name)
