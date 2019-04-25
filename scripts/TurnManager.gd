extends Node

export(int) var wait_time_per_tick = 0.15

onready var selection_manager = $"../SelectionManager"
onready var players = selection_manager.players
onready var attack_map = $"../AttackMap"

# used to determine when all agents have done all their actions queued
var agents_on_map = 2 # todo: better way to do this - create some stat
var agents_who_finished_actions_count = 0


func end_turn():
	for player in players:
		player.get_node("Char").action_queue.execute_all(wait_time_per_tick)
		
func get_player_names():
	return [players[0].get_name(), players[1].get_name()]

func _on_Char_action_queue_finished_executing(agent_name):
	agents_who_finished_actions_count += 1
	if agents_who_finished_actions_count >= agents_on_map:
		attack_map.clear()
		agents_who_finished_actions_count = 0
