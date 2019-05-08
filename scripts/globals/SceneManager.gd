extends Node

enum SCENES { TUTORIAL1, TUTORIAL2, TUTORIAL3, LEVEL1, LEVEL2, LEVEL3 }

const AgentMapPlacement = preload("res://scripts/globals/helpers/AgentMapPlacement.gd")

var map
var agents_to_create = create_scene_for_tutorial2() # list of Agent info for creation and placement of agents
var scene_name = "Tutorial 1"

# can change the Map, add enemies, change init placement of agents,
func load_scene(scene):
	match scene:
		SCENES.TUTORIAL1:
			agents_to_create = [
				AgentMapPlacement.new("player", [2, 1]),
				AgentMapPlacement.new("rat", [14, 6]),
			]
			scene_name = "Tutorial 1"
		SCENES.TUTORIAL2:
			create_scene_for_tutorial2()
			scene_name = "Tutorial 2"
		SCENES.TUTORIAL3:
			agents_to_create = [
				AgentMapPlacement.new("player", [2, 1]),
				AgentMapPlacement.new("rat", [8, 1]),
				AgentMapPlacement.new("rat", [14, 6]),
			]
			scene_name = "Tutorial 3"
		SCENES.LEVEL1:
			agents_to_create = [
				AgentMapPlacement.new("player", [2, 1]),
				AgentMapPlacement.new("rat", [8, 1]),
				AgentMapPlacement.new("rat", [14, 6]),
				AgentMapPlacement.new("rat", [0, 5]),
				AgentMapPlacement.new("rat", [4, 5]),
				AgentMapPlacement.new("rat", [8, 5]),
			]
			scene_name = "Level 1"
		SCENES.LEVEL2:
			agents_to_create = [
				AgentMapPlacement.new("player", [2, 1]),
				AgentMapPlacement.new("rat", [8, 1]),
				AgentMapPlacement.new("rat", [14, 6]),
				AgentMapPlacement.new("rat", [0, 5]),
				AgentMapPlacement.new("rat", [4, 5]),
				AgentMapPlacement.new("rat", [8, 5]),
				AgentMapPlacement.new("rat", [8, 8]),
				AgentMapPlacement.new("rat", [14, 5]),
				AgentMapPlacement.new("rat", [1, 5]),
				AgentMapPlacement.new("rat", [4, 6]),
				AgentMapPlacement.new("rat", [7, 5]),
			]
			scene_name = "Level 2"
		SCENES.LEVEL3:
			agents_to_create = [
				AgentMapPlacement.new("player", [2, 1]),
				AgentMapPlacement.new("rat", [8, 1]),
				AgentMapPlacement.new("rat", [14, 6]),
				AgentMapPlacement.new("rat", [0, 5]),
				AgentMapPlacement.new("rat", [4, 5]),
				AgentMapPlacement.new("rat", [8, 5]),
				AgentMapPlacement.new("rat", [8, 8]),
				AgentMapPlacement.new("rat", [14, 5]),
				AgentMapPlacement.new("rat", [1, 5]),
				AgentMapPlacement.new("rat", [4, 6]),
				AgentMapPlacement.new("rat", [7, 5]),
				AgentMapPlacement.new("rat", [8, 2]),
				AgentMapPlacement.new("rat", [4, 7]),
				AgentMapPlacement.new("rat", [8, 5]),
			]
			scene_name = "Level 3"
		_: # default
			print_debug("invalid scene given to SceneManager.load_scene")
		
	get_tree().change_scene("res://scenes/Root.tscn")	

func setup_scene(scene_root_node, map_node):
	# this func can be called before attrs of this instance are init
	if not agents_to_create: 
#		create_scene_for_tutorial2()
		load_scene(2)
		return setup_scene(scene_root_node, map_node)
	
	for agent in agents_to_create:
		agent.create_and_place(scene_root_node, map_node)
	
func create_scene_for_tutorial2():
	agents_to_create = [
		AgentMapPlacement.new("player", [2, 1]),
		AgentMapPlacement.new("rat", [8, 1]),
	]