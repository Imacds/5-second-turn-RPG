extends Node

export(int) var wait_time_per_tick = 0.15

signal begin_action_queues_execution()


onready var player_input_manager = get_tree().get_root().get_node("Root/PlayerInputManager")
onready var combat_ui = get_tree().get_root().get_node("Root/GeneralCamera/CombatUI")

const Player = preload("res://scripts/Player.gd")
const Agent = preload("res://scripts/Agent.gd")
var Utils = load("res://scripts/globals/Utils.gd")

var agents = []
onready var selection_manager = $"../SelectionManager"
onready var players = selection_manager.players
onready var AIs = []
onready var attack_map = $"../AttackMap"

var agent_count = len(agents)
var keep_going = false

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

func allow_inputs(var boolean):
	combat_ui.enabled = boolean
	player_input_manager.enabled = boolean

func end_turn():
	emit_signal("begin_action_queues_execution")
	
	allow_inputs(false)
	
	for ai in AIs:
		ai.get_node('AISystem').do_ai_stuff()
		
	agent_count = 0
	keep_going = false
	
	for agent in agents:
		agent.get_node("ActionQueue").execute_one(wait_time_per_tick, true)

func report_end_of_one(any_left):
	agent_count += 1
	keep_going = keep_going or any_left
	if agent_count >= len(agents):
		if keep_going: #There needs to be an extra call to successfully finish the turn
			for agent in agents:
				agent.get_node("ActionQueue").execute_one(wait_time_per_tick, false)
			agent_count = 0
			keep_going = false
		else:
			for agent in agents:
				agent.get_node("ActionQueue").finish_executing_one()
			agent_count = 0
			keep_going = false
			allow_inputs(true)
			$TurnTimer.start()
	
func get_player_names():
	return [players[0].get_name(), Utils.get_name(players[1])]

func _on_TurnTimer_timer_ended():
	end_turn()

func _on_ActionQueueManager_all_action_queues_finished_executing():
	pass
	#$TurnTimer.start()
