extends Control

var menu = false
var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_unhandled_key_input(true)
	set_process(true)
	

func _process(delta):
	if open:
		if menu:
			hide()
			get_tree().paused = false
			open = false
			
		menu = false

func _unhandled_key_input(event):
	if open:
		if event.is_action_pressed("ui_cancel"):
			menu = true
		elif event.is_action_released("ui_cancel"):
			menu = false

func _on_Resume_pressed():
	get_tree().paused = false
	hide()
	pass # Replace with function body.


func _on_Settings_pressed():
	get_tree().change_scene("res://game-objects/UI/Menu/SettingsMenu.tscn")
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().change_scene("res://scenes/StartMenu.tscn")
	pass # Replace with function body.

func open_menu():
	show()
	get_tree().paused = true
	menu = false
	open = true