extends Node

signal game_over(win_or_lose)

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
	agents_alive -= 1
	agent.disconnect("agent_died", self, "_on_Char_agent_died")
	
	if only_players_remain():
		emit_signal("game_over", "win")
		
		var timer = Timer.new()
		timer.wait_time = 1.5
		timer.one_shot = true
		timer.connect("timeout", self, "_on_Timer_timeout")
		timer.start()
		add_child(timer)
		
func _on_Timer_timeout():
	$"../LargeNotifyBanner".play_animation("Victory!", Color.green)