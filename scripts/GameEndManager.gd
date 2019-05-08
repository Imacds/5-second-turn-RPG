extends Node

signal game_over(win_or_lose)

onready var turn_manager = $"../TurnManager"
onready var agents = turn_manager.agents
onready var agents_alive = len(agents)

var end_state = "null"

func _ready():
	for agent in agents:
		agent.connect("agent_died", self, "_on_Char_agent_died")

func only_players_remain():
	for agent in agents:
		if agent.is_ai_agent() and not agent.is_dead():
			return false
		
	return true

func wait(seconds, callback):
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	timer.connect("timeout", self, callback)
	timer.start()
	add_child(timer)

func defeat():
	emit_signal("game_over", "lose")
	end_state = "Defeat!"
	wait(1.5, "_on_Timer_timeout")
		
func victory():
	emit_signal("game_over", "win")
	end_state = "Victory!"
	wait(1.5, "_on_Timer_timeout")

func _on_Char_agent_died(agent):
	agents_alive -= 1
	agent.disconnect("agent_died", self, "_on_Char_agent_died")
	
	if not agent.is_ai_agent():
		defeat()
	elif only_players_remain():
		victory()

func _on_Timer_timeout():
	$"../LargeNotifyBanner".play_animation(end_state, Color.green if end_state == "Victory!" else Color.red)
	wait(5, "_on_Timer2_timeout")
	
func _on_Timer2_timeout():
	get_tree().change_scene("res://scenes/SceneSelect.tscn")