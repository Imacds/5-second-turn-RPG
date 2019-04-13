extends Node

enum MODE { SLASH, SWING, LUNGE }
# the values are the change in angle (radians) to get to desired orientation
const DIRECTIONS = { 'up': 0, 'right': -PI / 2, 'down': PI, 'left': PI / 2 } # init pos is upwards (at PI / 2)

var threatened_tiles = {MODE.SLASH: [[0,-1],[1,-1],[1,0],[1,1],[0,1]], MODE.SWING: [[1,-1],[1,0],[1,1],[2,0]], MODE.LUNGE: [[1,0],[2,0],[3,0]]}

#onready var matrix = $AttackMatrix
var AttackMatrix = load("res://scripts/AttackMatrix.gd")
var hitbox_matrices = []

var click_mode = null


func _ready():
	hitbox_matrices = [ # 0: blank, 1: player, 2: hitbox, ... (see AttackMatrix.gd)
		AttackMatrix.new([ # slash
			2, 2, 2,
			2, 1, 2,
			0, 0, 0
		]),
		
		AttackMatrix.new([ # swing
			0, 2, 0,
			2, 2, 2,
			0, 1, 0
		]),
		
		AttackMatrix.new([ # lunge
			0, 0, 2, 0, 0,
			0, 0, 2, 0, 0,
			0, 0, 2, 0, 0,
			0, 0, 1, 0, 0,
			0, 0, 0, 0, 0
		]),
	]

func do_attack(position, attack_mode, attack_dir):
	pass

	
func visualize_attack(position, attack_mode, attack_dir):
	# get the atk matrix
	var atk_matrix = hitbox_matrices[int(attack_mode)]
	
	# rotate it to the same dir the player faces
	var rotated_matrix = atk_matrix.rotate(DIRECTIONS[attack_dir])
	
	# get the list of relative coords to player that'll be hitboxes
	var hitboxes = rotated_matrix.to_world_coords(position)
	
	print(hitboxes)