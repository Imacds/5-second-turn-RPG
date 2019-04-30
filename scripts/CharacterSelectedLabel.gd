extends Label

onready var selection_manager = get_tree().get_root().get_node("Root/SelectionManager")

func _process(delta):
	var player = selection_manager.selected
	text = player.get_name()