extends Node

const RATE = 0.5
var mode = 0
var counter = 0

func _ready():
	$"Char/Sprite".visible = false
	$"Char/PlayerAnimatedSprite".visible = false
	$"Char/AnimatedSprite".flip_h = true

func _process(delta):
	counter+= delta
	if counter >= RATE:
		counter = 0
		mode += 1
		if mode == 0:
			$'Char/AnimatedSprite'.rotation_degrees = -10.0
		elif mode == 1:
			$'Char/AnimatedSprite'.rotation_degrees = 0.0
		elif mode == 2:
			$'Char/AnimatedSprite'.rotation_degrees = 10.0
		elif mode == 3:
			$'Char/AnimatedSprite'.rotation_degrees = 0.0
			mode = -1