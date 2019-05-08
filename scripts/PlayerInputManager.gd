extends Node

onready var turn_manager = $"../TurnManager"
onready var selection_manager = $"../SelectionManager"
onready var attack_template = $"../AttackTemplate"

var enabled = true

func _unhandled_input(event):
	if enabled:
		var agent = selection_manager.selected.get_node('Char')
		
		# Movement
		var tss = agent.get_node('TileSelectorSprite')
		var path = agent.get_node('PlayerControlledPath')
		if tss.enabled and agent.can_move():
			if event.is_action_pressed("move_up"):
				tss.move_one_cell(Vector2.UP)
				path.draw_walkable(path.get_target_grid_pos())
			elif event.is_action_pressed("move_right"):
				tss.move_one_cell(Vector2.RIGHT)
				path.draw_walkable(path.get_target_grid_pos())
			elif event.is_action_pressed("move_down"):
				tss.move_one_cell(Vector2.DOWN)
				path.draw_walkable(path.get_target_grid_pos())
			elif event.is_action_pressed("move_left"):
				tss.move_one_cell(Vector2.LEFT)
				path.draw_walkable(path.get_target_grid_pos())
				
		# Attacks
		var attack_player = agent.get_node('Attack')
		if attack_template.get_click_mode() != null and agent.can_attack():
			if event.is_action_pressed("click"):
				agent.queue_attack_action(attack_template.get_click_mode(), attack_player.direction_str)
			if event.is_action_pressed("move_up"):
				agent.queue_attack_action(attack_template.get_click_mode(), attack_player.get_attack_dir_str(Vector2.UP))
			elif event.is_action_pressed("move_right"):
				agent.queue_attack_action(attack_template.get_click_mode(), attack_player.get_attack_dir_str(Vector2.RIGHT))
			elif event.is_action_pressed("move_down"):
				agent.queue_attack_action(attack_template.get_click_mode(), attack_player.get_attack_dir_str(Vector2.DOWN))
			elif event.is_action_pressed("move_left"):
				agent.queue_attack_action(attack_template.get_click_mode(), attack_player.get_attack_dir_str(Vector2.LEFT))