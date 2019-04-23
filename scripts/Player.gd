extends KinematicBody2D

###################
# editor vars #
###################
export(float) var SPEED = 300.0
export(int) var hp = 4
export(int) var walk_distance = 3
export(int) var action_points_per_turn = 3

###################
# signals #
###################
signal agent_enters_walk_mode(cell_coords)
signal agent_exits_walk_mode(cell_coords)

signal single_action_finished(action_name)
signal action_queue_finished_executing(agent_name) # only here to forward the signal from ActionQueue

###################
# enums #
###################
# idle is waiting for player input, wait is waiting for turn to end or player to complete action ?, turn indicates it's this player reads inputs & not the other
# waiting_for_all_actions is the current player does not read input, but is waiting for all queued actions of all actions to complete 
enum STATES { IDLE, WAIT, TURN, WAITING_FOR_ALL_ACTIONS } 
# null: read no input from this player, move: allow reading and queue for move action, attack: allow reading queue of attack action
enum COMMAND_MODES { NULL, MOVE, ATTACK }

###################
# attributes #
###################
var MoveAction = load("res://scripts/AgentActionSystem/MoveAction.gd")

var _state = STATES.TURN
var action_points = 3
var is_attack_turn = false
var path = []
var target_point_world = position
var target_position = Vector2()
var attack_mode = null # describes the type of attack if any. value from enum from AttackTemplate.gd
var command_mode = COMMAND_MODES.NULL # indicates allowed input reading for this player controlled character
var attack_dir = Vector2.LEFT
var direction = Vector2()

onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")
onready var selection_manager = get_tree().get_root().get_node("Root/SelectionManager")
onready var turn_manager = get_tree().get_root().get_node("Root/TurnManager")
onready var map = get_tree().get_root().get_node("Root/Map")
onready var attack_map = $"../../AttackMap"
onready var pathing = get_parent().get_node("Path")
onready var action_queue = $ActionQueue

var dragging = false

var is_moving = false
var target_pos = position
var character_target_position = position
var target_dir = Vector2()

var speed = 0
const Max_speed = 400

var velocity = Vector2()

###################
# methods #
###################
func _ready():
	_change_state(STATES.IDLE if is_selected() else STATES.TURN)
	_change_command_mode(COMMAND_MODES.MOVE)
	set_process_input(true)
	set_physics_process(true)
	

func get_cell_coords():
	return map.world_to_map(position)
	# get world position, size of individual cell, divide & truncate
#	var x = int(position.x / map.cell_size.x)
#	var y = int(position.y / map.cell_size.y)
#	return Vector2(x, y)
	

func _change_state(new_state):
#	if  new_state == STATES.IDLE:
#		emit_signal("agent_exits_walk_mode", get_cell_coords())
#	if new_state == STATES.WAIT:
#		path = pathing.get_path_relative(position, target_position)
#		if not path or len(path) == 1:
#			_change_state(STATES.IDLE)
#			return
#		# The index 0 is the starting cell
#		# we don't want the character to move back to it in this example
#		target_point_world = path[1]
	_state = new_state
	
func _change_command_mode(new_mode):
	if command_mode == COMMAND_MODES.MOVE:
		emit_signal("agent_exits_walk_mode", get_cell_coords())
	
	if action_points > 0:
		command_mode = new_mode
		
		if can_move():
			emit_signal("agent_enters_walk_mode", get_cell_coords())
	else:
		command_mode = COMMAND_MODES.NULL

func take_damage():
	hp = hp - 1

func render_hp():
	if hp >= 0:
		$Label.text = "HP: "
		for i in range(0, hp):
			$Label.text+= "O "
		for i in range(0, 4-hp):
			$Label.text+= "X "
	else:
		$Label.text = "DEAD"

func _process(delta):
	render_hp()
	
	if _state != STATES.TURN:
		return
	
#	if attack_mode != null and (attack_template.click_mode == null or selection_manager.selected == get_parent()):
	if can_attack():
		var dir_str = $Attack.get_attack_dir_str($Attack.get_relative_attack_dir())
		preview_attack(attack_mode, dir_str, attack_map.TILES.GREEN_ZONE_TO_ATTACK) # attack_template_attack_mode, dir_str, tile_type
		
	if attack_mode != null and is_attack_turn:
		attack_template.do_attack(get_cell_coords(), attack_mode, attack_dir, self)
		attack_mode = null
		_change_state(STATES.WAIT)
	else:
#		var arrived_to_next_point = move_to(target_point_world)
#		if arrived_to_next_point:
#			_change_state(STATES.WAIT)
#			path.remove(0)
#			if len(path) == 0:
#				_change_state(STATES.IDLE)
#				return
#			target_point_world = path[0]
		pass


func _physics_process(delta):
	move()
#	if character_target_position != position:
#		move_to(target_pos)
#	if _state != STATES.TURN and _state != STATES.IDLE:
		
#		var arrived_to_next_point = move_to(target_point_world)
#		if arrived_to_next_point:
#			_change_state(STATES.WAIT)
#			path.remove(0)
#			if len(path) == 0:
#				_change_state(STATES.IDLE)
#				return
#			target_point_world = path[0]


func move():
	if _state != STATES.TURN and _state != STATES.IDLE: # if we're not waiting for the other player to make their move and we're not in "not moving" state waiting for command input
		var arrived_to_next_point = move_to(target_point_world)
		if arrived_to_next_point:
			path.remove(0)
			print("moving to " + str(target_point_world))
			position = target_point_world
			if len(path) == 0:
				_change_state(STATES.IDLE)
				return
			_change_state(STATES.WAIT)
			target_point_world = path[0]
			emit_signal("single_action_finished", MoveAction.get_name())
		

func do_turn(is_attack_turn):
	self.is_attack_turn = is_attack_turn
	if _state == STATES.WAIT or attack_mode != null:
		_state = STATES.TURN
	else:
		attack_map.clear()


func move_to(world_position):	
	var MASS = 10.0
	var ARRIVE_DISTANCE = 0

	var desired_velocity = (world_position - position).normalized() * SPEED
	var steering = desired_velocity - velocity
	velocity += steering / MASS
	position += velocity * get_process_delta_time()
	
	return position.distance_to(world_position) <= ARRIVE_DISTANCE


func move_one_cell(direction):
	_change_state(STATES.WAIT)
	# get pos (cells)
	var coords = get_cell_coords()
	
	# get destination (cells)
	coords += direction
	
	# calc world destination
	var world_destination = map.map_to_world(coords, false) + map._half_cell_size# todo: why is this method giving the wrong world coords?
	target_point_world = world_destination
	path = [position, world_destination]

	var arrived = move_to(world_destination)
	

func _unhandled_input(event):
	if event.is_action_pressed("click"):
		if can_move(): 
			_change_command_mode(COMMAND_MODES.MOVE)
			action_points -= 1
			$ActionQueue.push(MoveAction.new([self, Vector2.RIGHT]))
		elif can_attack():
			var dir_str = $Attack.get_attack_dir_str($Attack.get_relative_attack_dir())
			preview_attack(attack_template.click_mode, dir_str, attack_map.TILES.YELLOW_ZONE_TO_ATTACK)
			attack_template.set_click_mode(null)
			_change_state(STATES.WAIT)
			_change_command_mode(COMMAND_MODES.MOVE)
			action_points -= 1

func preview_attack(attack_template_attack_mode, dir_str, tile_type):
	attack_template.visualize_attack(get_cell_coords(), attack_template_attack_mode, dir_str, self, tile_type) # position, attack_mode, attack_dir, owner, tile_type
	
func is_selected():
	return get_parent() == selection_manager.selected
	
func can_do_action():
	return action_points > 0 and is_selected() and _state != STATES.TURN
	
func can_attack():
	return can_do_action() and command_mode == COMMAND_MODES.ATTACK
	
func can_move():
	return can_do_action() and command_mode == COMMAND_MODES.MOVE

func _on_AttackTemplate_click_mode_changed(new_mode): # listener
	attack_mode = new_mode
	_change_command_mode(COMMAND_MODES.ATTACK)
	
func push_move_action(direction_vector):
	$ActionQueue.push(MoveAction.new([self, Vector2.RIGHT])) # todo update this

func _on_ActionQueue_finished_executing_actions(agent_name): # signal forwarding and turn end
	action_points = action_points_per_turn
	_change_state(STATES.IDLE if is_selected() else STATES.TURN)
	emit_signal("action_queue_finished_executing", agent_name)
