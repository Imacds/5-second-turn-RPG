extends Node

onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func do_ai_stuff():
	
	var do_move = true
	var move_dir = Vector2.UP
	
	var do_attack = true
	var attack_mode = attack_template.MODE.SWING
	var attack_dir = Vector2.UP
	
	var agent = get_parent().get_node('Char')
	
	if do_move:
	# Movement
		var tss = agent.get_node('TileSelectorSprite')
		var path = agent.get_node('PlayerControlledPath')
		if agent.not_out_of_points():
			tss.move_one_cell(move_dir)
			path.draw_walkable(path.get_target_grid_pos())
	
	if do_attack:		
	# Attacks
		var attack_player = agent.get_node('Attack')
		if attack_mode != null and agent.not_out_of_points():
			agent.queue_attack_action(attack_mode, attack_player.get_attack_dir_str(attack_dir))
