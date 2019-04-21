extends Node2D

signal selected_player_changed(player) 

onready var selected = get_parent().get_node("Player1")
onready var grid = get_tree().get_root().get_node("Root/Map")
onready var players = [get_parent().get_node("Player1"), get_parent().get_node("Player2")]

var index = 0

func toggle_control():
	index = (index + 1) % 2
	selected = players[index]
	emit_signal("selected_player_changed", selected)
