extends Node

onready var SMRT = get_node("DialogBox")
var bubble_pos = true
var num = 0


func _ready():
	SMRT.on_dialog = true
	ProjectSettings.set("money", 1000)
	if Input.is_key_pressed(KEY_0):
		SMRT.show_text("Beginning", "Say Something", num)
		num += 1
