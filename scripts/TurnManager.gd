extends Node

# Declare member variables here. Examples:
onready var players = [get_parent().get_node("Player1"), get_parent().get_node("Player2")]

func pass_turn():
	for player in players:
		player.get_node("Char").t = 2
		player.get_node("Char").do_turn()
		
		
func get_player_names():
	return [players[0].get_name(), players[1].get_name()]