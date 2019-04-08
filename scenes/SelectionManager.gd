extends Node2D

onready var selected = get_parent().get_node("Player1")

onready var grid = get_tree().get_root().get_node("Root/Map")

onready var players = [get_parent().get_node("Player1"), get_parent().get_node("Player2")]
var index = 0

func toggle_control():
	print(index)
	print(selected)
	index = (index + 1) % 2
	selected = players[index]

#func _unhandled_input(event):
#	if event.is_action_pressed('click') and Input.is_key_pressed(KEY_CONTROL):
#		var click_pos = get_global_mouse_position()
#		for player in players:
#			var player_pos = player.get_node("Char").get_global_position()
#			var dist = click_pos.distance_to(player_pos)
#			if dist <= grid.half_tile_size.x:
#				selected = player
		