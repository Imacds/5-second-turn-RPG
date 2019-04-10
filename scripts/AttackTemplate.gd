extends Node

enum MODE { SLASH, SWING, LUNGE }

var threatened_tiles = {MODE.SLASH: [[0,-1],[1,-1],[1,0],[1,1],[0,1]], MODE.SWING: [[1,-1],[1,0],[1,1],[2,0]], MODE.LUNGE: [[1,0],[2,0],[3,0]]}

var click_mode = null

func do_attack(position, attack_mode, attack_dir):
	pass