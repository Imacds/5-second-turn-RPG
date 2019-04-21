extends TileMap

enum TILES { ZONE_TO_ATTACK, YELLOW_ZONE_TO_ATTACK, GREEN_ZONE_TO_ATTACK, AGENT_CAN_MOVE_HERE, VOID }

var grid = []

var cell_set_queue = []

var GridElement = load("res://scripts/GridElement.gd")

export(Vector2) var map_size = Vector2(16, 16)

func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y

# param pos: type: Vector2 or list<int> of size 2. grid coordinates in range [0, map.size = 16)
func get_cell_content(pos):
	return grid[pos[0]][pos[1]] 

func _process(delta):
	if not cell_set_queue.empty():
		.clear() # remove all tiles from tile map
		for c in cell_set_queue:
			set_cell(c[0],c[1],c[2],c[3],c[4],c[5],c[6],c[7])
		cell_set_queue.clear()

func _ready():
	for x in range(map_size.x):
		grid.append([])
		for y in range(map_size.y):
			grid[x].append(GridElement.new("void", int(TILES.VOID), null, [x, y]))
			#grid[x].append(GridElement.new("empty", null, null, [x, y]))

func queue_set_cell(x, y, tile_index, owner = null, flip_x = false, flip_y = false, transpose = false, autotile_coord = Vector2(0, 0)):
		cell_set_queue.append([x, y, tile_index, owner, flip_x, flip_y, transpose, autotile_coord])

# override
func set_cell(x, y, tile_index, owner = null, flip_x = false, flip_y = false, transpose = false, autotile_coord = Vector2(0, 0)):
	if is_outside_map_bounds(Vector2(x, y)):
		return null
	
	var cell = get_cell_content(Vector2(x, y))
	#if cell.owner and not cell.owner == owner:
	#	print_debug("a diff owner tried to change a cell on the grid")
	#	return null
	
	.set_cell(x, y, tile_index, flip_x, flip_y, transpose, autotile_coord) # call super.set_cell
	grid[y][x] = GridElement.new("set_cell element", tile_index, owner, cell) 