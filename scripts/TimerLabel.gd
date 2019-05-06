extends Label

onready var timer = $"../TurnTimer"

func _on_TurnTimer_timeout(): # each 1 second tick
	set_text("Time: " + str(timer.time_remaining))
