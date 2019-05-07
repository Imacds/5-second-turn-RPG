extends Node2D

export(Color) var line_color = Color.green
export(Color) var dot_color = Color.green
export(float) var line_scaling = 1

var AttackMatrix = load("res://scripts/AttackMatrix.gd")

onready var agent = get_parent()
onready var owner_name = agent.get_name()
onready var walk_distance: int = agent.walk_distance
onready var attack_map = $"../../../AttackMap"
onready var Finder = get_node("/root/ObjectFinder") # Finder global
onready var map = Finder.get_node_from_root("Root/Map")

onready var path = [Vector2.ZERO]
onready var old_center = agent.target_point_world

var walk_matrix = [] # AttackMatrix

func _process(delta):
	position = agent.target_point_world - old_center

func _ready():
	for i in range(walk_distance + 1):
		walk_matrix.append(_generate_walk_matrix(i))
	
func _generate_walk_matrix(walking_distance):
	if walking_distance == 0:
		return AttackMatrix.new([
			0, 0, 0,
			0, 0, 0,
			0, 0, 0,
		])
	
	var matrix = []
	var size = walking_distance * 2 + 1
	
	var walkable_tiles = 1
	for row in range(size):
		var row_array = _surround_with_zeroes(2, walkable_tiles, size)
		matrix += row_array
		walkable_tiles += -2 if row > walking_distance else 2
		
	return AttackMatrix.new(matrix)
	
func _surround_with_zeroes(center_element: int, center_element_count: int, size: int):
	var array = []
	for i in range(center_element_count):
		array.append(center_element)
	
	var elements_per_side = (size - len(array)) / 2
	
	for i in range(elements_per_side):
		array.push_front(0)
		array.push_back(0)
		
	return array

func get_target_grid_pos():
	var grid_pos = agent.get_cell_coords()

	var point_start = path[0]
	var point_end = path[-1]

	var last_point = point_start
	for index in range(1, len(path)):
		var current_point = path[index]
		var direction = (current_point - last_point)/map.cell_size
		last_point = current_point

		if not(direction in [Vector2(0,1), Vector2(1,0), Vector2(0,-1), Vector2(-1,0)]):
			print_debug("Error in retracing direction: " + str(direction) + " !")
			return agent.get_cell_coords()
		else:
			grid_pos += direction

	return grid_pos

func _draw():
	draw_path()

func draw_path():
	var point_start = path[0]
	var point_end = path[-1]

	var last_point = point_start
	for index in range(1, len(path)):
		var current_point = path[index]
		draw_line(last_point, current_point, line_color, line_scaling, true)
		draw_circle(current_point, line_scaling * 2.0, dot_color)
		last_point = current_point

# color the tiles that can be walked to
func draw_walkable(agent_cell_coords):
	var cell_coords = get_agent_walkable_cell_coords(agent_cell_coords)
	#attack_map.clear_cells(owner_name, attack_map.TILES.AGENT_CAN_MOVE_HERE)
	attack_map.clear()

	#print("Tiles spawned in: " + str(len(cell_coords)))
	for coords in cell_coords:
		attack_map.set_cell(coords[0], coords[1], attack_map.TILES.AGENT_CAN_MOVE_HERE, owner_name) # x, y, tile_index, owner = null

func push_draw_path(direction: Vector2):
	path.append(path[-1] + direction * map.cell_size)
	update() # calls _draw to draw on canvas

func undo_last():
	path.pop_back()
	update()

func clear_draw_path():
	path = [Vector2.ZERO]
	old_center = agent.target_point_world
	update()

# returns: list of Vector2: world coordinates the agent can travel to sequentially to get to world_end
func get_path_relative(start, end):
	pass

func _on_Char_agent_enters_walk_mode(cell_coords):
	attack_map.clear()
	draw_walkable(cell_coords)
	$"../TileSelectorSprite".set_enabled(true)

func _on_Char_agent_exits_walk_mode(cell_coords):
	pass

func get_agent_walkable_cell_coords(agent_cell = null): # get the list of cell coords (lists) that the agent can walk to
	var ap = agent.action_points
	return walk_matrix[ap].to_world_coords(agent_cell if agent_cell else agent.get_cell_coords(), map.reachable_cell_constraint)
