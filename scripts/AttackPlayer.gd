extends Node2D

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
			
func draw_attack(type, dir):
	pass