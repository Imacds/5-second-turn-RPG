extends Node

enum ATTACKS { SLASH, SWING, LUNGE }

var threatened_tiles = {SLASH: [[0,-1],[1,-1],[1,0],[1,1],[0,1]], SWING: [[1,-1],[1,0],[1,1],[2,0]], LUNGE: [[1,0],[2,0],[3,0]]}

var click_mode = null
