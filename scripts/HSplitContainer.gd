extends HSplitContainer

onready var scene_manager = get_node("/root/SceneManager")

func _ready():
	$Label.text = str($HSlider.value)

func _on_HSlider_value_changed(value):
	$Label.text = str(value)
	scene_manager.turn_time = value
