extends Node

# Declare member variables here. Examples:
export(float) var x = $PlayerChar.transform.x setget _set_x
export(float) var y = $PlayerChar.transform.y setget _set_y

func _set_x(a):
	x = a
	$PlayerChar.transform.x = a
	
func _set_y(b):
	y = b
	$PlayerChar.transform.y = b

