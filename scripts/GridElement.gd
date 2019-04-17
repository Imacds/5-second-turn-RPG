var name # attributes
var tile_index
var owner
var grid_coords # x, y
var previous_element # for swapping tiles in place


func _init(ele_name, ele_tile_index, ele_owner, grid_coords, prev_element = null):
	name = ele_name
	tile_index = ele_tile_index
	owner = ele_owner
	self.grid_coords = grid_coords
	previous_element = prev_element
	
	
func set_cell_to_previous():
	var next = previous_element
	
	_init(next.name, next.tile_index, next.owner, next.grid_coords, self)
	
	return self