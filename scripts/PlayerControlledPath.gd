#
# TODO: pass map and constraint_func objs into methods to then filter walkable tiles
#
extends Node2D

export(Color) var line_color = Color.white
export(Color) var dot_color = Color.white
export(float) var line_scaling = 1

var AttackMatrix = load("res://scripts/AttackMatrix.gd")

onready var agent = get_parent()
onready var owner_name = agent.get_name()
onready var walk_distance: int = agent.walk_distance
onready var attack_map = $"../../../AttackMap"
onready var Finder = get_node("/root/ObjectFinder") # Finder global
onready var map = Finder.get_node_from_root("Root/Map")

onready var path = [agent.position]

var walk_matrix # AttackMatrix

func _ready():
	# todo: dont hard code this, generate it from agent walk distance
	walk_matrix = AttackMatrix.new([
		0, 0, 0, 2, 0, 0, 0,
		0, 0, 2, 2, 2, 0, 0,
		0, 2, 2, 2, 2, 2, 0,
		2, 2, 2, 1, 2, 2, 2,
		0, 2, 2, 2, 2, 2, 0,
		0, 0, 2, 2, 2, 0, 0,
		0, 0, 0, 2, 0, 0, 0
	])

func _draw():
	draw_path()

func draw_path():
	print(path)
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

	for coords in cell_coords:
		attack_map.set_cell(coords[0], coords[1], attack_map.TILES.AGENT_CAN_MOVE_HERE, owner_name) # x, y, tile_index, owner = null,

func push_draw_path(direction: Vector2):
	path.append(path[-1] + direction * map.cell_size)
	update() # calls _draw to draw on canvas
	
func clear_draw_path():
	path = [agent.positon]

# returns: list of Vector2: world coordinates the agent can travel to sequentially to get to world_end
func get_path_relative(start, end):
	pass

func _on_Char_agent_enters_walk_mode(cell_coords):
	draw_walkable(cell_coords)
	$TileSelectorSprite.set_enabled(true)

func _on_Char_agent_exits_walk_mode(cell_coords):
	attack_map.clear_cells(get_parent().get_name(), attack_map.TILES.AGENT_CAN_MOVE_HERE)
	$TileSelectorSprite.set_enabled(false)

func get_agent_walkable_cell_coords(agent_cell = null): # get the list of cell coords (lists) that the agent can walk to
	return walk_matrix.to_world_coords(agent_cell if agent_cell else agent.get_cell_coords(), attack_map.reachable_cell_constraint)
