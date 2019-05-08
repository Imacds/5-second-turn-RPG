extends Control

onready var SceneManager = get_node("/root/SceneManager")

func _on_MainMenu_button_pressed(): # go back to main menu button
	get_tree().change_scene("res://scenes/StartMenu.tscn")

func _on_Continue_button_pressed(): # level select button
	SceneManager.load_scene(0)
