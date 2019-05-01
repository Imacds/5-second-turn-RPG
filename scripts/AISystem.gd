extends Node

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
	$"../Char/AnimatedSprite".flip_h = true

func _process(delta):
	target_agent = selection_manager.selected.get_node('Char')
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func do_ai_stuff():
	rat_ai()

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

# The idea of the rat is to run up orthogonal to the player and try to bite it
func rat_ai():
	var attack_mode = attack_template.MODE.BITE
	
	var path = path_to_player(agent.get_cell_coords(),target_agent.get_cell_coords())
	
	var j = 0
	for i in range(0,3):
		if len(path) > 2+j:
			var dir = array_to_vec2(path[j+1]-path[j])
			do_move(dir)
			j+=1
		elif len(path) > 1:
			var dir = array_to_vec2(path[1]-path[0])
			do_attack(attack_mode, dir)
		else:
			do_move(Vector2.RIGHT)
	
func path_to_player(from, to):
	return map.get_point_path(map.vector2toarray(from), map.vector2toarray(to))
	