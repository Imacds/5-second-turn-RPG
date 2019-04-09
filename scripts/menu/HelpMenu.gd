extends Control

func _on_MainMenu_button_pressed():
	get_tree().change_scene("res://scenes/StartMenu.tscn")

func _on_Continue_button_pressed():
	get_tree().change_scene("res://scenes/Root.tscn")

