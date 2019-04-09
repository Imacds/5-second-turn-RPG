extends KinematicBody2D

onready var player = get_parent().get_node("Player")
#onready var player2 = get_node("res://Scene/Player2.tscn")
var speed = 0
const Max_speed = 400
var is_moving = false
var target_pos = Vector2()
var target_dir = Vector2()
onready var grid = get_parent().get_node('Map')
var velocity = Vector2()
var direction = Vector2()
var type
var player_moving = false

func _ready():
	player_moving = false
	player = get_parent().get_node("Player")

func _process(delta):
	direction = Vector2()
	speed = 0
	if player_moving:
		direction = grid._calculate_path_to_player(self, player)

func _physics_process(delta):
	if not is_moving and direction != Vector2():
		target_dir = direction
		if grid.is_cell_empty(position, target_dir):
			target_pos = grid.update_child_pos(self)
			is_moving = true
	elif is_moving:
		speed = Max_speed
		velocity = speed * target_dir * delta
		var pos = position
		
		var distance_to_target = pos.distance_to(target_pos)
		var move_distance = velocity.length()
		if move_distance > distance_to_target:
			velocity = target_dir * distance_to_target
			is_moving = false
		distance_to_target = Vector2(abs(target_pos.x - pos.x) , abs(target_pos.y - pos.y))
		if abs(velocity.x) > distance_to_target.x:
			velocity.x = distance_to_target.x * target_dir.x
			is_moving = false
		if abs(velocity.y) > distance_to_target.y:
			velocity.x = distance_to_target.y * target_dir.y
			is_moving = false
		player_moving = false
		move_and_collide(velocity)