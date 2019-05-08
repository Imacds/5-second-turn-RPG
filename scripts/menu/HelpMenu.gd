extends Control

onready var SceneManager = get_node("/root/SceneManager")

func _on_MainMenu_button_pressed(): # go back to main menu button
	get_tree().change_scene("res://scenes/StartMenu.tscn")

func _on_Tut1_pressed():
	SceneManager.load_scene(0)

func _on_Tut2_pressed():
	SceneManager.load_scene(1)

func _on_Tut3_pressed():
	SceneManager.load_scene(2)

func _on_Level1_pressed():
	SceneManager.load_scene(3)

func _on_Level2_pressed():
	SceneManager.load_scene(4)

func _on_Level3_pressed():
	SceneManager.load_scene(5)
