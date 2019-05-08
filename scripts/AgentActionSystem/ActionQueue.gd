extends Node

signal begin_executing_actions(agent_name)
signal finished_executing_actions(agent_name)

var one_at_a_time = false
var max_size
var queue = []

onready var parent_name = get_parent().get_name()
onready var sounds = $"../CharSounds"
onready var attack = $"../AttackPath"
onready var turn_manager = get_tree().get_root().get_node("Root/TurnManager")
var WaitAction = load("res://scripts/AgentActionSystem/WaitAction.gd")

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
	one_at_a_time = false
	emit_signal("begin_executing_actions", parent_name)
	$Timer.set_wait_time(wait_time_between_actions)
	$Timer.start()

func execute_one(wait_time_between_actions = 0.15, first = true):
	one_at_a_time = true
	if first:
		emit_signal("begin_executing_actions", parent_name)
		$Timer.set_wait_time(wait_time_between_actions)
	$Timer.start()

func finish_executing_one():
	$Timer.stop()
	emit_signal("finished_executing_actions", parent_name)

func get_queue():
	return queue

func _on_Timer_timeout():
	if not queue.empty() and not $"../".is_dead(): # more to execute & agent is not dead
		var wait = queue[0] is WaitAction
		queue[0].execute()
		sounds.play_corresponding_sound(queue[0])
		attack.play_action(queue[0])		
		queue.pop_front()
		if not one_at_a_time or wait:
			$Timer.start()
		else:
			$Timer.stop()
			turn_manager.report_end_of_one(true)
	else:
		if one_at_a_time:
			turn_manager.report_end_of_one(false) # this guarantees it will always report back
		else:
			$Timer.stop()
			emit_signal("finished_executing_actions", parent_name)
		
