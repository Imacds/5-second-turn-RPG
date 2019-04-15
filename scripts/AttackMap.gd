extends TileMap

# Declare member variables here. Examples:
enum TILES { ZONE_TO_ATTACK }

var grid = []

var cell_set_queue = []

export(Vector2) var map_size = Vector2(16, 16)

func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y

func get_cell_content(pos):
	return grid[pos.x][pos.y] 
	
class GridElement:
	var name # attributes
	var tile_index
	var owner
	var previous_element # for swapping tiles in place
	
	func _init(ele_name, ele_tile_index, ele_owner, prev_element = null):
		name = ele_name
		tile_index = ele_tile_index
		owner = ele_owner
		previous_element = prev_element

func _process(delta):
	if not cell_set_queue.empty():
		.clear()
		for c in cell_set_queue:
			set_cell(c[0],c[1],c[2],c[3],c[4],c[5],c[6],c[7])
		cell_set_queue.clear()

func _ready():
	for x in range(map_size.x):
		grid.append([])
		for y in range(map_size.y):
			grid[x].append(GridElement.new("zone_of_attack", 1, null))

func queue_set_cell(x, y, tile_index, owner = null, flip_x = false, flip_y = false, transpose = false, autotile_coord = Vector2(0, 0)):
		cell_set_queue.append([x, y, tile_index, owner, flip_x, flip_y, transpose, autotile_coord])

# override
func set_cell(x, y, tile_index, owner = null, flip_x = false, flip_y = false, transpose = false, autotile_coord = Vector2(0, 0)):
	if is_outside_map_bounds(Vector2(x, y)):
		print_debug("attempted to set cell outside of boundaries of grid")
		return null

	var cell = get_cell_content(Vector2(x, y))
	if cell.owner and not cell.owner == owner:
		print_debug("a diff owner tried to change a cell on the grid")
		return null

	.set_cell(x, y, tile_index, flip_x, flip_y, transpose, autotile_coord) # call super.set_cell
	grid[y][x] = GridElement.new("set_cell element", tile_index, owner, cell) 