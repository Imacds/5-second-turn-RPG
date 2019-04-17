extends RichTextLabel

# Declare member variables here. Examples:
var dialog = ["This is 6 second RPG created by Gridventure", "Enjoy the game!"]
var page = 0
var isDone = false
onready var DialogBox = get_parent()
onready var label = DialogBox.get_node("Label")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_bbcode(dialog[page])
	set_visible_characters(0)
	set_process_input(true)
	isDone = false

func _process(delta):
	if get_visible_characters() < get_total_character_count():
		label.text = "Press any key to skip"
	else:
		label.text = "Press any key to continue"

func _input(event):
	
	if event is InputEventKey or event is InputEventMouseButton:
		if event.pressed:
			if isDone:
				DialogBox.visible = false
			else:
				if get_visible_characters() > get_total_character_count():
					if page < dialog.size() - 1:
						page += 1
						set_bbcode(dialog[page])
						set_visible_characters(0)
					else:
						isDone = true
				else:
					set_visible_characters(get_total_character_count())

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)
	
	if get_visible_characters() > get_total_character_count():
		if page >= dialog.size() - 1:
			isDone = true
