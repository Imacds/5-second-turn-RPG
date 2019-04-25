extends Node

signal click_mode_changed(new_mode)

enum MODE { SLASH, SWING, LUNGE }
onready var DIRECTIONS = { 'up': 0, 'right': 90, 'down': 180, 'left': 270 } # init pos is upwards (at PI / 2)

onready var AttackMatrix = load("res://scripts/AttackMatrix.gd")
var hitbox_matrices = []

var click_mode = null

onready var attack_map = $"../AttackMap" # sibling of this node
onready var selection_manager = $"../SelectionManager"
onready var turn_manager = $"../TurnManager"

func _ready():
	hitbox_matrices = [ # 0: blank, 1: player, 2: hitbox, ... (see AttackMatrix.gd)
		AttackMatrix.new([ # slash
			2, 2, 2,
			2, 1, 2,
			0, 0, 0
		]),
		
		AttackMatrix.new([ # swing
			0, 0, 2, 0, 0,
			0, 2, 2, 2, 0,
			0, 0, 1, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
		]),
		
		AttackMatrix.new([ # lunge
			0, 0, 0, 2, 0, 0, 0,
			0, 0, 0, 2, 0, 0, 0,
			0, 0, 0, 2, 0, 0, 0,
			0, 0, 0, 1, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0
		]),
	]


func set_click_mode(mode):
	click_mode = mode
	emit_signal("click_mode_changed", mode)

# param position: cell coords
func do_attack(position, attack_mode, attack_dir, owner):
	visualize_attack(position, attack_mode, attack_dir, owner, attack_map.TILES.ZONE_TO_ATTACK)
	damage_in_attack_radius(position, attack_mode, attack_dir, owner)

# param position: cell coords
func damage_in_attack_radius(position, attack_mode, attack_dir, owner):
	# get the atk matrix
	var atk_matrix = hitbox_matrices[int(attack_mode)]
	
	# rotate it to the same dir the player faces
	var rotated_matrix = atk_matrix.rotate(DIRECTIONS[attack_dir])

	# get the list of relative coords to player that'll be hitboxes
	var hitboxes = rotated_matrix.to_world_coords(position)
	
	for coords in hitboxes:
		for player in turn_manager.players:
			if player.get_node("Char").get_cell_coords() == Vector2(coords[0], coords[1]):
				player.get_node("Char").take_damage()
	

func visualize_attack(position, attack_mode, attack_dir, owner, tile_type):
#	if not position or not attack_mode: 
#		return
	
	# get the atk matrix
	var atk_matrix = hitbox_matrices[int(attack_mode)]
	
	# rotate it to the same dir the player faces
	var rotated_matrix = atk_matrix.rotate(DIRECTIONS[attack_dir])

	# get the list of relative coords to player that'll be hitboxes
	var hitboxes = rotated_matrix.to_world_coords(position)
	
	for coords in hitboxes:
		attack_map.queue_set_cell(coords[0], coords[1], int(tile_type), owner) # x, y, tile_index, owner = null,