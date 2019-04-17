extends Node

# Declare member variables here. Examples:
onready var players = [get_parent().get_node("Player1"), get_parent().get_node("Player2")]
onready var attack_map = $"../AttackMap"
var amount = 3


func pass_turn():
	
	for i in range(0, amount):
		#Ticks a turn
		attack_map.clear()
		do_one_turn(i == 1)
		
		#Waits 3 seconds
		var t = Timer.new()
		t.set_wait_time(1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		
	attack_map.clear()
	
func do_one_turn(is_attack_turn):
	for player in players:
		player.get_node("Char").do_turn(is_attack_turn)
		
func get_player_names():
	return [players[0].get_name(), players[1].get_name()]