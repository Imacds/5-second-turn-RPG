extends Sprite

var enabled = false
var inputs_queue = []

<<<<<<< HEAD
onready var Finder = get_node("/root/ObjectFinder") # Finder global
onready var agent = $"../../../Char"
onready var map = Finder.get_node_from_root("Root/Map")
onready var path = $"../../PlayerControlledPath"


=======
onready var orignal_position = position
onready var map = $"../../../Char".map # relative path, but contained within this tscn
onready var path = $"../../PlayerControlledPath"

>>>>>>> 1c1f796aec86c869b9ed3b34f9444f606aee69a9
func _ready():
	set_enabled(false)

func _input(event):
	if enabled:
		if event.is_action("move_up"):
			move_one_cell(Vector2.UP)
		if event.is_action("move_right"):
<<<<<<< HEAD
=======
			print('move right')
>>>>>>> 1c1f796aec86c869b9ed3b34f9444f606aee69a9
			move_one_cell(Vector2.RIGHT)
		if event.is_action("move_down"):
			move_one_cell(Vector2.DOWN)
		if event.is_action("move_left"):
			move_one_cell(Vector2.LEFT)

func reset_position():
<<<<<<< HEAD
	position = Vector2() # position is relative; (0, 0) is on parent

# param dir: unit vector for direction (Vector2.RIGHT, Vector2.LEFT, etc)
func move_one_cell(direction: Vector2): 
	var next_pos = agent.position + position + direction * map._half_cell_size
	if is_walkable(next_pos):
		position = next_pos - agent.position # position is relative to this

# set visibility and reset position
func set_enabled(enabled):
	reset_position()
	self.enabled = enabled
	visible = enabled
	
func is_walkable(next_position):
	# don't allow moving out of bounds
	# don't allow moving outside of agent movable tiles
	var walkable_cells = path.get_agent_walkable_cell_coords() # todo: cache this in PlayerControlledPath
	var destination_cell = map.world_to_mapa(next_position)
	
	print(walkable_cells)
=======
	position = orignal_position

# param dir: unit vector for direction (Vector2.RIGHT, Vector2.LEFT, etc)
func move_one_cell(direction: Vector2): 
	var next_pos = position + direction * map._half_cell_size
	if is_walkable(next_pos):
		position = next_pos

# set visibility and reset position if making it disabled
func set_enabled(enabled):
	self.enabled = enabled
	visible = enabled
	
	if not enabled:
		reset_position()
		
func is_walkable(next_position):
	# don't allow moving out of bounds
	# don't allow moving outside of agent movable tiles
	var walkable_cells = path.get_agent_walkable_cell_coords()
	var destination_cell = map.world_to_map(next_position)
	
>>>>>>> 1c1f796aec86c869b9ed3b34f9444f606aee69a9
	return destination_cell in walkable_cells
