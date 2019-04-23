extends Control
#onready var settings = get_node("/root/Settings")

func _ready():
	#if settings.musicEnable:
	#	print (settings.musicEnable)
	#	$background_music.play()
	pass

func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Root.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_Help_pressed():
	get_tree().change_scene("res://game-objects/UI/Menu/HelpMenu.tscn")

func _on_Settings_pressed():
	get_tree().change_scene("res://game-objects/UI/Menu/SettingsMenu.tscn")
