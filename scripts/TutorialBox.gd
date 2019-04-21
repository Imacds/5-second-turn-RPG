extends Polygon2D

func _ready():
	set_process_input(true)
	pass # Replace with function body.

func _input(event):
	if Input.is_key_pressed(KEY_K):
		self.visible = false
