extends Control
#onready var settings = get_node("/root/Settings")

func _ready():
	#if settings.musicEnable:
	#	print (settings.musicEnable)
	#	$background_music.play()
	return

func _on_StartButton_pressed():
	print(get_tree())
	get_tree().change_scene("res://Scene/Root.tscn")
	pass # replace with function body


func _on_ExitButton_pressed():
	get_tree().quit()
	pass # replace with function body


func _on_Help_pressed():
	get_tree().change_scene("res://Scene/HelpMenu.tscn")
	pass # replace with function body


func _on_Settings_pressed():
	get_tree().change_scene("res://Scene/SettingsMenu.tscn")
	pass # replace with function body
