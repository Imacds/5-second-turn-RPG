extends Camera2D

# editor vars #
export (float) var speed = 700
export (float) var allow_horizontal_movement = false

onready var window_size = OS.get_screen_size()
onready var default_center = position


func _physics_process(delta):
	move(delta)
	
	
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

	direction = direction.normalized()
	position += direction * speed * delta

	var upper_limit = 725 # todo: calc dynamic upper limit
	position.y = clamp(position.y, default_center.y, upper_limit)