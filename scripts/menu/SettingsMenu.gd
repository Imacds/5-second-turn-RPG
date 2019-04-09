extends Control
onready var settings = get_node("/root/Settings")
var music_box
var sound_box
func _ready():
	#music_box = settings.musicEnable
	#sound_box = settings.soundEnable
	#$CenterContainer/VBoxContainer/CenterContainer/VButtonContainer/MusicBox.pressed = music_box
	#$CenterContainer/VBoxContainer/CenterContainer/VButtonContainer/SoundBox.pressed = sound_box
	pass

func _on_ExitButton_pressed():
	get_tree().change_scene("res://scenes/StartMenu.tscn")

func _on_CheckBox_toggled(button_pressed):
	music_box = button_pressed
	settings.musicEnable = button_pressed

func _on_SoundBox_toggled(button_pressed):
	sound_box = button_pressed
	settings.soundEnable = button_pressed
