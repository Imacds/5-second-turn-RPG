extends Node

onready var player_selected_label = $ColorRect/CharacterSelectionRect/CharacterSelection/CharacterSelectedLabel

func _on_SelectionManager_selected_player_changed(player):
	player_selected_label.set_text(player.get_name())
