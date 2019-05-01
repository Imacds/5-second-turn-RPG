extends Label

onready var timer = $"../TurnTimer"

func _on_TurnTimer_timeout():
	set_text("Time: " + str(timer.time_remaining))
