extends TileMap

enum TILES { ZONE_TO_ATTACK, YELLOW_ZONE_TO_ATTACK, GREEN_ZONE_TO_ATTACK, AGENT_CAN_MOVE_HERE, VOID }

export(Vector2) var map_size = Vector2(16, 16)

var grid = []
var cell_set_queue = []

onready var reachable_cell_constraint = funcref(self, "reachable_cell_constraint_func")
onready var Utils = get_node("/root/Utils/")
var GridElement = load("res://scripts/GridElement.gd")


func _ready():
	for x in range(map_size.x):
		grid.append([])
		for y in range(map_size.y):
			grid[x].append(GridElement.new("void", int(TILES.VOID), null, [x, y]))

func is_outside_map_bounds(point):
	return point[0] < 0 or point[1] < 0 or point[0] >= map_size.x or point[1] >= map_size.y

# param pos: type: Vector2 or list<int> of size 2. grid coordinates in range [0, map.size = 16)
func get_cell_content(pos):
	return grid[pos[0]][pos[1]] 

func _process(delta):
	if not cell_set_queue.empty():
		.clear() # remove all tiles from tile map
		for c in cell_set_queue:
			set_cell(c[0],c[1],c[2],c[3],c[4],c[5],c[6],c[7])
		cell_set_queue.clear()

func queue_set_cell(x, y, tile_index, owner = null, flip_x = false, flip_y = false, transpose = false, autotile_coord = Vector2(0, 0)):
		cell_set_queue.append([x, y, tile_index, owner, flip_x, flip_y, transpose, autotile_coord])

# override
func set_cell(x, y, tile_index, owner = null, flip_x = false, flip_y = false, transpose = false, autotile_coord = Vector2(0, 0)):
	if is_outside_map_bounds(Vector2(x, y)):
		return null
	
	var cell = get_cell_content(Vector2(x, y))
	
	.set_cell(x, y, tile_index, flip_x, flip_y, transpose, autotile_coord) # call super.set_cell
	grid[y][x] = GridElement.new("set_cell element", tile_index, owner, cell) 
	
# clear (remove) tiles/cells from map where the cell owner or/and tile_index matches
func clear_cells(owner = null, tile_index = null):
	if not owner and tile_index == null: # nothing to clear
		print("warning: you called clear_cells without any owner or tile_index, do you mean to call clear() ?")
		return
	
	for y in range(map_size.y):
		for x in range(map_size.x):
			var cell = get_cell_content([x, y])
			if owner and tile_index != null: # owner and tile_index specified to be cleared
				if cell.owner == owner and cell.tile_index == tile_index:
					set_cell(x, y, int(TILES.VOID), null)
			elif owner and cell.owner == owner: # only cells of owner to be cleared
				 set_cell(x, y, int(TILES.VOID), null)
			elif cell.tile_index == tile_index: # only cells of tile_index to be cleared
				 set_cell(x, y, int(TILES.VOID), null)

# filter func - remove falsey values later down the pipe
func reachable_cell_constraint_func(cell_coord: Array) -> bool:
	# todo: do a* pathing and check to see if cell is on wall/obstacle or walks through a wall
	return not is_outside_map_bounds(cell_coord)