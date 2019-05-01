extends Control

onready var selection_manager = get_tree().get_root().get_node("Root/SelectionManager")
onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")
onready var turn_manager = get_tree().get_root().get_node("Root/TurnManager")
onready var map = get_tree().get_root().get_node("Root/Map")
onready var agent = selection_manager.selected.get_node('Char')

var menu = false
var open = false
var visibile = true
var go_to_goal_pos = true
var kill_all_enemies = true
var goal_pos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_unhandled_key_input(true)
	set_process(true)

func path_to_player(from, to):
	return map.get_point_path(map.vector2toarray(from), map.vector2toarray(to))

func goal_movement():
	if go_to_goal_pos:
		if len(path_to_player(agent.get_cell_coords(), goal_pos)) > 1:
			return false
	return true

func goal_kill():
	if kill_all_enemies:
		for enemy_agent in turn_manager.agents:
			if enemy_agent != agent and not enemy_agent.is_dead():
				return false

func num_kill():
	var c = 0
	if kill_all_enemies:
		for enemy_agent in turn_manager.agents:
			if enemy_agent != agent and not enemy_agent.is_dead():
				c+=1
	return c

func goal_met():
	var movement = goal_movement()
	var kill = goal_kill()
	return movement and kill

func _process(delta):
	
	agent = selection_manager.selected.get_node('Char')
	if agent.is_dead():
		$'PauseContainer/VBoxContainer/MarginContainer/CenterContainer/Label'.text = "YOU DIED"
		open_menu()
		
	print(goal_met())
	if goal_met():
		$'PauseContainer/VBoxContainer/MarginContainer/CenterContainer/Label'.text = "YOU WIN"
		open_menu()
	
	if open:
		if menu:
			hide()
			get_tree().paused = false
			open = false
			
		menu = false

func _on_Exit_pressed():
	get_tree().change_scene("res://scenes/StartMenu.tscn")
	pass # Replace with function body.

func open_menu():
	show()
	get_tree().paused = true
	menu = false
	open = true