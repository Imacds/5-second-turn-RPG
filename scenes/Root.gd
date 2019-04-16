extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var SMRT = get_node("DialogBox")
var bubble_pos = true
var num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("hello")
	SMRT.on_dialog = true
	ProjectSettings.set("money", 1000)
	if Input.is_key_pressed(KEY_0):
		print("hello")
		SMRT.show_text("Beginning", "Say Something", num)
		num += 1
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
