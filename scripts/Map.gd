extends TileMap

# You can only create an AStar node from code, not from the Scene tab
onready var astar_node = AStar.new()
# The Tilemap node doesn't have clear bounds so we're defining the map's limits here
export(Vector2) var map_size = Vector2(16, 16)

var grid = []

var GridElement = load("res://scripts/GridElement.gd")

onready var tile_size = cell_size
onready var half_tile_size = tile_size / 2

# get_used_cells_by_id is a method from the TileMap node
# here the id 0 corresponds to the grey tile, the obstacles
onready var obstacles = get_used_cells_by_id(3)
onready var _half_cell_size = cell_size / 2

enum TILES { VOID0, VOID1, VOID2, WALL, GROUND, VOID5 }


func _ready():
	for x in range(map_size.x):
		grid.append([])
		for y in range(map_size.y):
			grid[x].append(GridElement.new("walkable", 3, null, [x, y]))
			
	for id in obstacles:
		grid[id.x][id.y] = GridElement.new("obstacle", 4, null, [id.x, id.y])
		
	var walkable_cells_list = astar_add_walkable_cells(obstacles)
	astar_connect_walkable_cells(walkable_cells_list)
	

func get_cell_content(pos):
	return grid[pos[0]][pos[1]]
	

func is_cell_empty(pos, direction):
	var grid_pos = world_to_map(pos) + direction
	if grid_pos.x < map_size.x and grid_pos.x >= 0:
		if grid_pos.y < map_size.y and grid_pos.y >= 0:
			return true if grid[grid_pos.x][grid_pos.y] == null else false
	return false


# Loops through all cells within the map's bounds and
# adds all points to the astar_node, except the obstacles
func astar_add_walkable_cells(obstacles = []):
	var points_array = []
	for y in range(map_size.y):
		for x in range(map_size.x):
			var point = Vector2(x, y)
			if point in obstacles:
				continue

			points_array.append(point)
			# The AStar class references points with indices
			# Using a function to calculate the index from a point's coordinates
			# ensures we always get the same index with the same input point
			var point_index = calculate_point_index(point)
			# AStar works for both 2d and 3d, so we have to convert the point
			# coordinates from and to Vector3s
			astar_node.add_point(point_index, Vector3(point.x, point.y, 0.0))
	return points_array


# Once you added all points to the AStar node, you've got to connect them
# The points don't have to be on a grid: you can use this class
# to create walkable graphs however you'd like
# It's a little harder to code at first, but works for 2d, 3d,
# orthogonal grids, hex grids, tower defense games...
func astar_connect_walkable_cells(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		# For every cell in the map, we check the one to the top, right.
		# left and bottom of it. If it's in the map and not an obstalce,
		# We connect the current point with it
		var points_relative = PoolVector2Array([
			Vector2(point.x + 1, point.y),
			Vector2(point.x - 1, point.y),
			Vector2(point.x, point.y + 1),
			Vector2(point.x, point.y - 1)])
		for point_relative in points_relative:
			var point_relative_index = calculate_point_index(point_relative)

			if is_outside_map_bounds(point_relative):
				continue
			if not astar_node.has_point(point_relative_index):
				continue
			# Note the 3rd argument. It tells the astar_node that we want the
			# connection to be bilateral: from point A to B and B to A
			# If you set this value to false, it becomes a one-way path
			# As we loop through all points we can set it to false
			astar_node.connect_points(point_index, point_relative_index, false)


# This is a variation of the method above
# It connects cells horizontally, vertically AND diagonally
func astar_connect_walkable_cells_diagonal(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		for local_y in range(3):
			for local_x in range(3):
				var point_relative = Vector2(point.x + local_x - 1, point.y + local_y - 1)
				var point_relative_index = calculate_point_index(point_relative)

				if point_relative == point or is_outside_map_bounds(point_relative):
					continue
				if not astar_node.has_point(point_relative_index):
					continue
				astar_node.connect_points(point_index, point_relative_index, true)


func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y


func calculate_point_index(point):
	return point.x + map_size.x * point.y
	
	
# override
func set_cell(x, y, tile_index, owner = null, flip_x = false, flip_y = false, transpose = false, autotile_coord = Vector2(0, 0)):
	if is_outside_map_bounds(Vector2(x, y)):
		return null

	var cell = get_cell_content(Vector2(x, y))
	if cell.owner and not cell.owner == owner:
		print_debug("a diff owner tried to change a cell on the grid")
		return null

	.set_cell(x, y, tile_index, flip_x, flip_y, transpose, autotile_coord) # call super.set_cell
	grid[y][x] = GridElement.new("set_cell element", tile_index, owner, cell) 


func cell_coords_to_world_position(cell_coords):
	var x = cell_coords[0] * cell_size.x + _half_cell_size.x
	var y = cell_coords[0] * cell_size.y + _half_cell_size.y
	
	return Vector2(x, y)
