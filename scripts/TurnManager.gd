extends Node

export(int) var wait_time_per_tick = 0.15

signal begin_action_queues_execution()

const Player = preload("res://scripts/Player.gd")
const Agent = preload("res://scripts/Agent.gd")
var Utils = load("res://scripts/globals/Utils.gd")

var agents = []
onready var selection_manager = $"../SelectionManager"
onready var players = selection_manager.players
onready var AIs = []
onready var attack_map = $"../AttackMap"

func _ready():
	find_all_agents()
	
func find_all_agents():
	_get_agents_recursively(get_parent())

func _get_agents_recursively(node):
	for child in node.get_children():
		if child is Agent or child is Player: # Char / Player.gd
			agents.append(child)
		if child.get_node("AISystem") != null: # RatAgent w/ children: Char, AISystem
			AIs.append(child)
		_get_agents_recursively(child)

func end_turn():
	emit_signal("begin_action_queues_execution")
	
	for ai in AIs:
		ai.get_node('AISystem').do_ai_stuff()
		
	for agent in agents:
		agent.get_node("ActionQueue").execute_all(wait_time_per_tick)
	
func get_player_names():
	return [players[0].get_name(), Utils.get_name(players[1])]

func _on_TurnTimer_timer_ended():
	end_turn()

func _on_ActionQueueManager_all_action_queues_finished_executing():
	$TurnTimer.start()
