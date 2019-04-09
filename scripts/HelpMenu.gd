extends Control

func _on_MainMenu_button_pressed():
	get_tree().change_scene("res://Scene/StartMenu.tscn")
	pass # replace with function body


func _on_Continue_button_pressed():
	get_tree().change_scene("res://Scene/Root.tscn")
	pass # replace with function body
