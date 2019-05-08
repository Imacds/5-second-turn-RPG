extends Node

const PlayerAgent = preload("res://game-objects/PlayerAgent.tscn")
const RatAgent = preload("res://game-objects/RatAgent.tscn")

var agent_class
var init_cell_coords
var node_name

func _init(agent_type_name, cell_coords):
	if agent_type_name == "player":
		agent_class = PlayerAgent
		node_name = "Player1"
	elif agent_type_name == "rat":
		agent_class = RatAgent
		node_name = "RatAgent"
		
	init_cell_coords = cell_coords

func create_and_place(scene_root_node, map_node):
	var agent = agent_class.instance()
	agent.set_name(node_name)
	
	var init_pos = map_node.map_to_world(Vector2(init_cell_coords[0], init_cell_coords[1]), true)
	init_pos += map_node.cell_size / 2
	
	agent.get_node("Char").position = init_pos
	scene_root_node.add_child(agent)
