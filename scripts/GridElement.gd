#onready var Utils = get_node("/root/Utils") # Utils global
var Utils = load("res://scripts/globals/Utils.gd") # Utils global

var name # attributes
var tile_index
var owner
var grid_coords # x, y
var previous_element # for swapping tiles in place


func _init(ele_name, ele_tile_index, ele_owner, grid_coords, prev_element = null):
	name = Utils.get_name(ele_name) # call get_name() on the obj unless it's a string
	tile_index = ele_tile_index
	owner = ele_owner
	self.grid_coords = grid_coords
	previous_element = prev_element
	
	
func set_cell_to_previous():
	var next = previous_element
	
	_init(next.name, next.tile_index, next.owner, next.grid_coords, self)
	
	return self