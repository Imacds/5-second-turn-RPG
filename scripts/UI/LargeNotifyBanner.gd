extends ColorRect

var animation_name = "TurnChangeAnim"

func play_animation(text, bg_color = Color.black):
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	
#	set_modulate(bg_color)
	color = bg_color
	$TurnChangeLabel.set_text(text)
	$AnimationPlayer.play(animation_name)

func set_animation_speed(speed: float): # speed in range (0, inf)
	$AnimationPlayer.set_speed_scale(speed)