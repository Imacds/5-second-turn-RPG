extends Node

enum SCENES { TUTORIAL1, TUTORIAL2, TUTORIAL3, LEVEL1, LEVEL2, LEVEL3 }

const AgentMapPlacement = preload("res://scripts/globals/helpers/AgentMapPlacement.gd")

var map
var agents_to_create # list of Agent info for creation and placement of agents
var scene_name = "Tutorial 1"
var dialog = null

# can change the Map, add enemies, change init placement of agents,
func load_scene(scene, load_the_scene = true):
	match scene:
		SCENES.TUTORIAL1: # place a scarecrow close
			agents_to_create = [
				AgentMapPlacement.new("player", [2, 1]),
				AgentMapPlacement.new("scarecrow", [8, 1]),
			]
			scene_name = "Tutorial 1"
			dialog = ["Welcome to 6 second rpg by Gridventure", "This is a safe place to practice, the training dummy does not fight back", "Plan your movement with WASD", "Press Q and a movement to queue up a short range slash attack","Press E and a movement to queue up a medium range swing attack","Press R and a movement to queue up a long range lunge attack","You can view your plan in the bottom left. You may take up to 2 action a turn","Z can be used to undo the latest queued item from your plan","Remember, the turn timer can be lengthened in the options menu","Good Luck!"]
		SCENES.TUTORIAL2: # place an AI pretty close
			agents_to_create = [
				AgentMapPlacement.new("player", [2, 1]),
				AgentMapPlacement.new("rat", [8, 1]),
			]
			dialog = ["Let's step it up a notch", "This rat will run after you. It can bite you if you get close","Hit it a few times and it shouldn't be much of a problem.", "Remember, you have a time limit to enter turns!"]
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
		
	if load_the_scene:
		get_tree().change_scene("res://scenes/Root.tscn")	

func setup_scene(scene_root_node, map_node):
	# this func can be called before attrs of this instance are init
	if not agents_to_create: 
		load_scene(SCENES.TUTORIAL2) 
		return setup_scene(scene_root_node, map_node)
	
	for agent in agents_to_create:
		agent.create_and_place(scene_root_node, map_node)
