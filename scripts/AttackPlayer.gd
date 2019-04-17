extends Node2D

const BASE_LINE_WIDTH = 3.0
export(Color) var DRAW_COLOR = Color('#fff')

func get_relative_attack_dir():
	var difference = get_global_mouse_position() - global_position
	if abs(difference.x) > abs(difference.y):
		if difference.x >= 0:
			return Vector2(1,0)
		else:
			return Vector2(-1,0)
	else:
		if difference.y >= 0:
			return Vector2(0,1)
		else:
			return Vector2(0,-1)

func get_attack_dir_str(vector2):
	var dir_str = 'right'
	match vector2:
		Vector2(0,-1): dir_str = 'up'
		Vector2(0,1): dir_str = 'down'
		Vector2(-1,0): dir_str = 'left'
		Vector2(1,0): dir_str = 'right'
	return dir_str
			
func draw_attack(mode, dir):
	draw_circle(position, BASE_LINE_WIDTH * 2.0, Color(1,0,0,0.5))
	
func clear_attack():
	pass

func flash_attack(mode, dir):
	draw_attack(mode, dir)
	OS.delay_msec(1000)
	clear_attack()	
       