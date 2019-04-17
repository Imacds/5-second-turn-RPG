extends Node2D

# The path start and end variables use setter methods
# You can find them at the bottom of the script
var path_start_position = Vector2() setget _set_path_start_position
var path_end_position = Vector2() setget _set_path_end_position

var _point_path = []
var keyUsed = false

onready var selection_manager = get_tree().get_root().get_node("Root/SelectionManager")
onready var grid = get_tree().get_root().get_node("Root/Map")

const BASE_LINE_WIDTH = 3.0
export(Color) var DRAW_COLOR = Color('#fff')


func get_path_relative(world_start, world_end):
	self.path_start_position = grid.world_to_map(world_start)
	self.path_end_position = grid.world_to_map(world_end)
	_recalculate_path()
	var path_world = []
	for point in _point_path:
		var point_world = grid.map_to_world(Vector2(point.x, point.y)) + grid._half_cell_size
		path_world.append(point_world)
	return path_world


func _recalculate_path():
	clear_previous_path_drawing()
	var start_point_index = grid.calculate_point_index(path_start_position)
	var end_point_index = grid.calculate_point_index(path_end_position)
	# This method gives us an array of points. Note you need the start and end
	# points' indices as input
	_point_path = grid.astar_node.get_point_path(start_point_index, end_point_index)
	# Redraw the lines and circles from the start to the end point
	
	update()


func clear_previous_path_drawing():
	if not _point_path:
		return
		
	var point_start = _point_path[0]
	var point_end = _point_path[len(_point_path) - 1]
		
	#set_cell(point_start.x, point_start.y, -1)
	#set_cell(point_end.x, point_end.y, -1)


func _draw():
	if not keyUsed:
		if not _point_path:
			return
		var point_start = _point_path[0]
		var point_end = _point_path[len(_point_path) - 1]
			
		#set_cell(point_start.x, point_start.y, 0)
		#set_cell(point_end.x, point_end.y, 1)
	
		var last_point = grid.map_to_world(Vector2(point_start.x, point_start.y)) + grid._half_cell_size
		for index in range(1, len(_point_path)):
			var current_point = grid.map_to_world(Vector2(_point_path[index].x, _point_path[index].y)) + grid._half_cell_size
			draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
			draw_circle(current_point, BASE_LINE_WIDTH * 2.0, DRAW_COLOR)
			last_point = current_point

# Setters for the start and end path values.
func _set_path_start_position(value):
	if value in grid.obstacles:
		return
	if grid.is_outside_map_bounds(value):
		return

	#set_cell(path_start_position.x, path_start_position.y, -1)
	#set_cell(value.x, value.y, 0)
	path_start_position = value
	if path_end_position and path_end_position != path_start_position:
		_recalculate_path()


func _set_path_end_position(value):
	if value in grid.obstacles:
		#adding attack if the obstacles is enemy
		return
	if grid.is_outside_map_bounds(value):
		return

	#set_cell(path_start_position.x, path_start_position.y, -1)
	#set_cell(value.x, value.y, 0)
	path_end_position = value
	if path_start_position != value:
		_recalculate_path()


func update_line(position, direction):
	# Move a child to a new position in the grid Array
	# Returns the new target world position of the child 
	var grid_pos = grid.world_to_map(position)
	var new_grid_pos = grid_pos + direction
	var target_pos = grid.map_to_world(new_grid_pos) + grid.half_tile_size
	_set_path_end_position(new_grid_pos)
	return target_pos
	
	
func pop_path():
	_point_path.remove(0)