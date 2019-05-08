extends Node

export(int) var hp = 2
export(String) var enemy_type = 'rat'

onready var selection_manager = get_tree().get_root().get_node("Root/SelectionManager")
onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")
onready var map = get_tree().get_root().get_node("Root/Map")
onready var agent = get_parent().get_node('Char')
onready var tss = agent.get_node('TileSelectorSprite')
onready var path = agent.get_node('PlayerControlledPath')
onready var attack_player = agent.get_node('Attack')

var target_agent

func _ready():
	$"../Char/Sprite".visible = false
	$"../Char/PlayerAnimatedSprite".visible = false
	$"../Char/AnimatedSprite".flip_h = true
	agent.hp = hp
	
func _process(delta):
	target_agent = selection_manager.selected.get_node('Char')
	
func do_ai_stuff():
	if enemy_type == 'rat':
		rat_ai()
	if enemy_type == 'scarecrow':
		scarecrow_ai()
	if enemy_type == 'swing':
		swing_ai()
	if enemy_type == 'range':
		range_ai()

func do_move(move_dir):	
	# Move
	if agent.not_out_of_points():
		tss.move_one_cell(move_dir)
		path.draw_walkable(path.get_target_grid_pos())
	
func do_attack(attack_mode, attack_dir):
	# Attack
	if attack_mode != null and agent.not_out_of_points():
		agent.queue_attack_action(attack_mode, attack_player.get_attack_dir_str(attack_dir))

func array_to_vec2(array):
	return Vector2(array[0],array[1])

#do nothin
func scarecrow_ai():
	pass

func in_a_line(var path, var dist):
	var index = min(len(path)-1, dist)
	var dir = array_to_vec2(path[index]-path[0])
	if (dir.x == 0 || dir.y == 0) && dir.distance_to(Vector2.ZERO) <= dist:
		return true
	return false

#do nothin
func swing_ai():
	var attack_mode = attack_template.MODE.SWING
	
	var path = Array(path_to_player(agent.get_cell_coords(),target_agent.get_cell_coords(), false))
	var attack_dist = 2
	var random_move = Vector2.LEFT
	do_generic_action(path, attack_dist, attack_mode, random_move)
	
#do nothin
func range_ai():
	var attack_mode = attack_template.MODE.RANGE
	
	var path = Array(path_to_player(agent.get_cell_coords(),target_agent.get_cell_coords(), true))
	var attack_dist = 4
	var random_move = Vector2.DOWN
	do_generic_action(path, attack_dist, attack_mode, random_move)

# The idea of the rat is to run up orthogonal to the player and try to bite it
func rat_ai():
	var attack_mode = attack_template.MODE.BITE
	
	var path = Array(path_to_player(agent.get_cell_coords(),target_agent.get_cell_coords(), false))
	var attack_dist = 1
	var random_move = Vector2.RIGHT
	do_generic_action(path, attack_dist, attack_mode, random_move)
	
func path_to_player(from, to, line_greed):
	return map.get_point_path(map.vector2toarray(from), map.vector2toarray(to), line_greed)
	
func do_generic_action(var path, var attack_dist, var attack_mode, var random_move):
		for i in range(0, 2):
			if len(path) > attack_dist+1 or !in_a_line(path,attack_dist):
				var dir = array_to_vec2(path[1]-path[0])
				do_move(dir)
				path.pop_front()
			elif len(path) > 1 and in_a_line(path,attack_dist):
				var dir = array_to_vec2(path[1]-path[0])
				do_attack(attack_mode, dir)
			else:
				do_move(random_move)