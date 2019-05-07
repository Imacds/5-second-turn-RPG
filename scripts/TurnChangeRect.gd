extends ColorRect

var animation_name = "TurnChangeAnim"

func play_animation(text):
	print(text)
	$TurnChangeLabel.text = text
	$AnimationPlayer.play(animation_name)
