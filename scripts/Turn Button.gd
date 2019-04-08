extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

onready var selection_manager = get_tree().get_root().get_node("Root/SelectionManager")

func _on_Button2_pressed():
	selection_manager.toggle_control()


