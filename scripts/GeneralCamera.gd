extends Camera2D

# editor vars #
export (float) var speed = 700
export (float) var allow_horizontal_movement = false

onready var window_size = OS.get_screen_size()
onready var default_center = position
onready var pause_menu = get_parent().get_node("PauseMenu")

var menu = false

#func _process(delta):
#	if menu:
#		pause_menu.open_menu()
#	menu = false
