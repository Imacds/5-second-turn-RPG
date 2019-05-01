extends Node

export(int) var wait_time_per_tick = 0.15

const Player = preload("res://scripts/Player.gd")
const Agent = preload("res://scripts/Agent.gd")

var agents = []
onready var selection_manager = $"../SelectionManager"
onready var players = selection_manager.players
onready var attack_map = $"../AttackMap"

func _ready():
	find_all_agents()
	
func find_all_agents():
	_get_agents_recursively(get_parent())

func _get_agents_recursively(node):
	for child in node.get_children():
		if child is Agent or child is Player:
			agents.append(child)
		_get_agents_recursively(child)

func end_turn():
	for agent in agents:
		agent.get_node("ActionQueue").execute_all(wait_time_per_tick)
		
func get_player_names():
	return [players[0].get_name(), players[1].get_name()]

func _on_TurnTimer_timer_ended():
	end_turn()

func _on_ActionQueueManager_all_action_queues_finished_executing():
	$TurnTimer.start()
