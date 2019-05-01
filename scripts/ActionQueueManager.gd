extends Node

signal all_action_queues_finished_executing()

const ActionQueue = preload("res://scripts/AgentActionSystem/ActionQueue.gd")

var action_queues = []
var queues_finished = 0

func _ready():
	find_all_action_queues()
	listen_to_each_action_queue()
	
func find_all_action_queues():
	_get_action_queues_recursively(get_parent())
	
func _get_action_queues_recursively(node):
	for child in node.get_children():
		if child is ActionQueue:
			action_queues.append(child)
		_get_action_queues_recursively(child)
		
func listen_to_each_action_queue():
	for queue in action_queues:
		queue.connect("finished_executing_actions", self, "_on_ActionQueue_finished_executing_actions")
		
func _on_ActionQueue_finished_executing_actions(agent_name):
	queues_finished += 1
	if queues_finished >= len(action_queues):
		emit_signal("all_action_queues_finished_executing")
		queues_finished = 0