extends Timer

signal timer_ended()

export(float) var time_per_turn = 6

var time_remaining = time_per_turn

func _on_TurnTimer_timeout():
	time_remaining = clamp(time_remaining - wait_time, 0, INF)
	if time_remaining <= 0:
		stop()
		time_remaining = time_per_turn
		emit_signal("timer_ended")
