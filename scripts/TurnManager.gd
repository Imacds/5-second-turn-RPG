extends Node

export(int) var wait_time_per_tick = 0.15

onready var selection_manager = $"../SelectionManager"
onready var players = selection_manager.players
onready var attack_map = $"../AttackMap"

# used to determine when all agents have done all their actions queued
var agents_on_map = 2 # todo: better way to do this
var agents_who_finished_actions_count = 0


func end_turn():
	for player in players:
		player.get_node("Char").action_queue.execute_all(wait_time_per_tick)
	
#	for i in range(0, amount):
#		#Ticks a turn
#		attack_map.clear()
#		do_one_turn(i == 1)
#
#		#Waits 3 seconds
#		var timer = Timer.new()
#		timer.set_wait_time(wait_time_per_tick)
#		timer.set_one_shot(true)
#
#		add_child(timer)
#		timer.start()
#
#		yield(timer, "timeout")
#		timer.queue_free()
#
#	attack_map.clear()
	
func do_one_turn(is_attack_turn):
	for player in players:
		player.get_node("Char").do_turn(is_attack_turn)
		
func get_player_names():
	return [players[0].get_name(), players[1].get_name()]

func _on_Char_action_queue_finished_executing(agent_name):
	agents_who_finished_actions_count += 1
	if agents_who_finished_actions_count >= agents_on_map:
		attack_map.clear()
