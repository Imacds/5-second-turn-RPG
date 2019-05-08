extends ColorRect

var animation_name = "TurnChangeAnim"

func play_animation(text):
	print(get_children())
	$TurnChangeLabel.set_text(text)
	$AnimationPlayer.play(animation_name)

func set_animation_speed(speed: float): # speed in range (0, inf)
	$AnimationPlayer.set_speed_scale(speed)