extends Node2D

# param direction: Vector2
# param attack_mode: AttackTemplate.MODE
signal attack_selected(direction, attack_mode)

const BASE_LINE_WIDTH = 3.0
export(Color) var DRAW_COLOR = Color('#fff')

var direction_str


onready var agent = get_parent()
onready var attack_map = $"../../../AttackMap"
onready var attack_template = $"../../../AttackTemplate"


func _process(delta):
	if agent.can_attack(): # agent selected, can do action, and in attack command mode
		if attack_template.get_click_mode() != null:
			direction_str = get_attack_dir_str(get_relative_attack_dir())
			agent.preview_attack(attack_template.get_click_mode(), direction_str, attack_map.TILES.GREEN_ZONE_TO_ATTACK) # attack_template_attack_mode, dir_str, tile_type

func get_relative_attack_dir():
	var difference = get_global_mouse_position() - global_position
	if abs(difference.x) > abs(difference.y):
		if difference.x >= 0:
			return Vector2(1,0)
		else:
			return Vector2(-1,0)
	else:
		if difference.y >= 0:
			return Vector2(0,1)
		else:
			return Vector2(0,-1)

func get_attack_dir_str(vector2):
	var dir_str = 'right'
	match vector2:
		Vector2(0,-1): dir_str = 'up'
		Vector2(0,1): dir_str = 'down'
		Vector2(-1,0): dir_str = 'left'
		Vector2(1,0): dir_str = 'right'
	return dir_str
			
func draw_attack(mode, dir):
	draw_circle(position, BASE_LINE_WIDTH * 2.0, Color(1,0,0,0.5))
	
func clear_attack():
	pass

func flash_attack(mode, dir):
	draw_attack(mode, dir)
	OS.delay_msec(1000)
	clear_attack()


func _on_Char_agent_enters_attack_mode(cell_coords):
	pass # Replace with function body.


func _on_Char_agent_exits_attack_mode(cell_coords):
	pass # Replace with function body.
