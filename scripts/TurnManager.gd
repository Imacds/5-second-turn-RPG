extends Node

# Declare member variables here. Examples:
onready var players = [get_parent().get_node("Player1"), get_parent().get_node("Player2")]

func pass_turn():
	for player in players:
		player.get_node("Char").do_turn()
		