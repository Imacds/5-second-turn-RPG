extends RichTextLabel

# Declare member variables here. Examples:
var dialog = ["This is 6 second RPG created by Gridventure", "Enjoy the game"]
var page = 0
onready var DialogBox = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	set_bbcode(dialog[page])
	set_visible_characters(0)
	set_process_input(true)
	pass # Replace with function body.

func _input(event):
	
	if event is InputEventKey or event is InputEventMouseButton:
		if event.pressed:
			if page < len(dialog)-1:
				if get_visible_characters() > get_total_character_count():
					if page < dialog.size() - 1:
						page += 1
						set_bbcode(dialog[page])
						set_visible_characters(0)
				else:
					set_visible_characters(get_total_character_count())
			else:
				DialogBox.visible = false

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)
	pass # Replace with function body.
