extends Control

var open = false
var visibile = true

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_unhandled_key_input(true)
	set_process(true)

func _process(delta):
	if not $SettingsMenu.settingsVisibile:
		get_node("PauseContainer").show()

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		open_menu() if not open else hide_menu()

func _on_Resume_pressed():
	get_tree().paused = false
	hide()

func _on_Settings_pressed():
	get_node("PauseContainer").hide()
	get_node("SettingsMenu").show()

func _on_Exit_pressed():
	_on_Resume_pressed()
	get_tree().change_scene("res://scenes/StartMenu.tscn")

func open_menu():
	show()
	get_tree().paused = true
	open = true
	
func hide_menu():
	hide()
	get_tree().paused = false
	open = false