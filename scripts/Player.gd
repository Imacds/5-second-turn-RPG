extends KinematicBody2D

###################
# editor vars #
###################
export(float) var speed = 300
export(float) var max_speed = 400
export(float) var mass = 10.0
export(int) var hp = 4
export(int) var walk_distance = 2
export(int) var action_points_per_turn = 2

###################
# signals #
###################
signal agent_enters_walk_mode(cell_coords)
signal agent_exits_walk_mode(cell_coords)

signal agent_enters_attack_mode(cell_coords)
signal agent_exits_attack_mode(cell_coords)

signal single_action_finished(action_name)
signal action_queue_finished_executing(agent_name) # only here to forward the signal from ActionQueue

signal agent_died(agent)

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
var AttackAction = load("res://scripts/AgentActionSystem/AttackAction.gd")
var WaitAction = load("res://scripts/AgentActionSystem/WaitAction.gd")

var _state = STATES.TURN
var command_mode = COMMAND_MODES.NULL # indicates allowed input reading for this player controlled character
var action_points = action_points_per_turn
var target_point_world = position

onready var Finder = get_node("/root/ObjectFinder")

onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")
onready var selection_manager = get_tree().get_root().get_node("Root/SelectionManager")
onready var map = get_tree().get_root().get_node("Root/Map")
onready var attack_map = Finder.get_node_from_root("Root/AttackMap")
onready var action_queue = $ActionQueue
onready var action_queue_manager = Finder.get_node_from_root("Root/ActionQueueManager")

var velocity = Vector2()

###################
# methods #
###################
func _ready():
	_change_state(STATES.IDLE if is_selected() else STATES.TURN)
	_change_command_mode(COMMAND_MODES.MOVE)
	set_process_input(true)
	set_physics_process(true)
	
	
	# listen to action queue manager signal
	action_queue_manager.connect("all_action_queues_finished_executing", self, "_on_ActionQueueManager_all_action_queues_finished_executing")
	
	# listen to attack template signal
	attack_template.connect("click_mode_changed", self, "_on_AttackTemplate_click_mode_changed")

func get_position():
	return position

func get_cell_coords():
	return map.world_to_map(position)

func _change_state(new_state):
	_state = new_state

func _change_command_mode(new_mode):
	if command_mode == COMMAND_MODES.MOVE:
		emit_signal("agent_exits_walk_mode", get_cell_coords())
	elif command_mode == COMMAND_MODES.ATTACK:
		emit_signal("agent_exits_attack_mode", get_cell_coords())

	if action_points > 0:
		command_mode = new_mode

		if can_move():
			attack_template.click_mode = null
			emit_signal("agent_enters_walk_mode", get_cell_coords())
		elif can_attack():
			emit_signal("agent_enters_attack_mode", get_cell_coords())
	else:
		command_mode = COMMAND_MODES.NULL

func take_damage():
	hp = hp - 1
	$CharSounds.play_effect($CharSounds.sound_damaged)
	if is_dead():
		die()

func is_dead():
	return hp < 0

func render_hp():
	if hp >= 0:
		$Label.text = "HP: "
		for i in range(0, hp):
			$Label.text += "X "
	else:
		$Label.text = ""

func _process(delta):
	render_hp()

func _physics_process(delta):
	_move()
	
func die():
	$Sprite.visible = false
	if $AnimatedSprite:
		$AnimatedSprite.visible = false
		
	$CharDeathAnimation.play()
	$CharSounds.play_effect($CharSounds.sound_death)
	action_points = 0
	action_points_per_turn = 0
	
	emit_signal("agent_died", self)

func _move():
	if _state != STATES.TURN and _state != STATES.IDLE: # if we're not waiting for the other player to make their move and we're not in "not moving" state waiting for command input
		if move_to(target_point_world):
			_change_state(STATES.WAIT)
			emit_signal("single_action_finished", MoveAction.get_name())

func move_to(world_position):
	var arrive_distance = 0

	var desired_velocity = (world_position - position).normalized() * speed
	var steering = desired_velocity - velocity
	velocity += steering / mass
	position += velocity * get_process_delta_time()

	return position.distance_to(world_position) <= arrive_distance

func move_one_cell(direction):
	_change_state(STATES.WAIT)
	# get pos (cells)
	var coords = get_cell_coords()

	# get destination (cells)
	coords += direction

	# calc world destination
	var world_destination = map.map_to_world(coords, false) + map._half_cell_size # todo: why is this method giving the wrong world coords?
	target_point_world = world_destination

	var arrived = move_to(world_destination)

func preview_attack(attack_template_attack_mode, dir_str, tile_type):
	attack_template.visualize_attack($PlayerControlledPath.get_target_grid_pos(), attack_template_attack_mode, dir_str, self, tile_type) # position, attack_mode, attack_dir, owner, tile_type

func is_selected():
	return get_parent() == selection_manager.selected

func not_out_of_points():
	return action_points > 0
	
func can_do_action():
	return action_points > 0 and is_selected() and _state != STATES.TURN

func can_attack():
	return can_do_action() and command_mode == COMMAND_MODES.ATTACK

func can_move():
	return can_do_action() and command_mode == COMMAND_MODES.MOVE
	
func is_ai_agent():
	return not not $"../AISystem"

func queue_move_action(direction: Vector2):
	var action = MoveAction.new(self, direction)
	if MoveAction.can_do_action(action, action_points) and $ActionQueue.push(action):
		$PlayerControlledPath.push_draw_path(direction)
		action_points -= action.get_cost()
		if action_points <= 0:
			$"TileSelectorSprite".set_enabled(false)
	else: # not enough AP or queue is full
		_change_state(STATES.TURN)
		_change_command_mode(COMMAND_MODES.NULL)

func undo_last_action():
	var last = action_queue.peek_back()
	if last != null:
		action_points += last.get_cost()
		if last is AttackAction:
			_change_command_mode(COMMAND_MODES.MOVE)
			action_queue.pop_back()
			action_queue.pop_back()
		elif last is MoveAction:
			_change_command_mode(COMMAND_MODES.MOVE)
			action_queue.pop_back()
			$PlayerControlledPath.undo_last()
			$TileSelectorSprite.undo_one_move(last.direction) #WARNING: needs to be after PlayerControlledPath.undo_last() to work
		else:
			print_debug("A wierd state is being undone...")
			action_queue.pop_back()

func queue_attack_action(attack_mode, dir_str):
	var action = AttackAction.new(self, dir_str, attack_template, attack_mode) # agent, direction_str, attack_template, attack_mode, execution_cost = 1
	attack_map.clear()
	
	if is_selected():
		attack_template.visualize_attack($PlayerControlledPath.get_target_grid_pos(), attack_mode, dir_str, self, attack_map.TILES.YELLOW_ZONE_TO_ATTACK) # position, attack_mode, attack_dir, owner, tile_type

	attack_template.set_click_mode(null)
	var queue_had_room = $ActionQueue.push(WaitAction.new()) and $ActionQueue.push(action)

	if AttackAction.can_do_action(action, action_points) and queue_had_room:
		action_points -= action.get_cost()
		_change_state(STATES.IDLE)
		_change_command_mode(COMMAND_MODES.MOVE)
	else: # not enough AP or queue is full
		_change_state(STATES.TURN)
		_change_command_mode(COMMAND_MODES.NULL)

# override
func get_name():
	return get_parent().get_name()

###################
# event listeners #
###################
func _on_SelectionManager_selected_player_changed(player):
	if is_selected(): # switched to this player
		attack_map.clear()
		_change_state(STATES.IDLE)
		_change_command_mode(COMMAND_MODES.MOVE)
	else:
		_change_state(STATES.TURN)
		_change_command_mode(COMMAND_MODES.NULL)
		$TileSelectorSprite.set_enabled(false)

func _on_AttackTemplate_click_mode_changed(new_mode): # enter attack command mode
	if is_selected():
		_change_state(STATES.IDLE)
		_change_command_mode(COMMAND_MODES.ATTACK)

func _on_ActionQueue_begin_executing_actions(agent_name): # begin the action execution of actions from queue
	_change_state(STATES.TURN)
	_change_command_mode(COMMAND_MODES.NULL)
	attack_map.clear()
	$TileSelectorSprite.set_enabled(false)
	$PlayerControlledPath.clear_draw_path()

func _on_ActionQueue_finished_executing_actions(agent_name): # turn end and signal forwarding
	emit_signal("action_queue_finished_executing", agent_name) # forward the signal

func _on_ActionQueueManager_all_action_queues_finished_executing():
	action_points = action_points_per_turn
	_change_state(STATES.IDLE if is_selected() else STATES.TURN)
	_change_command_mode(COMMAND_MODES.MOVE if is_selected() else COMMAND_MODES.NULL)
	$TileSelectorSprite.reset_position()
	$PlayerControlledPath.clear_draw_path()
