extends Node

var SceneManager

onready var SMRT = get_node("DialogBox")
var dialog_box_counter = 0

func _enter_tree():
	SceneManager = get_node("/root/SceneManager")
	SceneManager.setup_scene(self, get_node("Map"))

func _ready():
	pass

func dialog_box():
	SMRT.on_dialog = true
	ProjectSettings.set("money", 1000)
	if Input.is_key_pressed(KEY_0):
		SMRT.show_text("Beginning", "Say Something", dialog_box_counter)
		dialog_box_counter += 1