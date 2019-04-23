extends Camera2D

# editor vars #
export (float) var speed = 700
export (float) var allow_horizontal_movement = false

onready var window_size = OS.get_screen_size()
onready var default_center = position
onready var pauseMenu = get_parent().get_node("PauseMenu")

var menu = false


func _physics_process(delta):
	move(delta)
	
func _input(event):
	if event.is_action_pressed("ui_cancel") and pauseMenu.open == false:
		menu = true
	elif event.is_action_released("ui_cancel"):
		menu = false
	
	
func move(delta):
	var direction = Vector2()

	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if allow_horizontal_movement and Input.is_action_pressed("move_left"):
		direction.x -= 1
	if allow_horizontal_movement and Input.is_action_pressed("move_right"):
		direction.x += 1
		
	if menu:
		pauseMenu.open_menu()
	menu = false
		

	direction = direction.normalized()
	position += direction * speed * delta

	var upper_limit = 725 # todo: calc dynamic upper limit
	position.y = clamp(position.y, default_center.y, upper_limit)