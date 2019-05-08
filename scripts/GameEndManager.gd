extends Node

signal game_over()

onready var turn_manager = $"../TurnManager"
onready var agents = turn_manager.agents
onready var agents_alive = len(agents)

func _ready():
	for agent in agents:
		agent.connect("agent_died", self, "_on_Char_agent_died")

func only_players_remain():
	for agent in agents:
		if agent.is_ai_agent() and not agent.is_dead():
			return false
		
		return true

func _on_Char_agent_died(agent):
	print('die')
	agents_alive -= 1
	agent.disconnect("agent_died", self, "_on_Char_agent_died")
	if only_players_remain():
		print('vectory')
		$"../TurnManager/TurnTimer".set_paused(true)
		$"../LargeNotifyBanner".play_animation("Victory!", Color.green)