extends Node

#func _ready():
#	find_all_action_queues()
#	listen_to_each_action_queue()
#
#func find_all_action_queues():
#	_get_action_queues_recursively(get_parent())
#
#func _get_action_queues_recursively(node):
#	for child in node.get_children():
#		if child is ActionQueue:
#			action_queues.append(child)
#		_get_action_queues_recursively(child)
#
#func listen_to_each_action_queue():
#	for queue in action_queues:
#		queue.connect("finished_executing_actions", self, "_on_ActionQueue_finished_executing_actions")