extends Sprite

var enabled = false
var inputs_queue = []

onready var orignal_position = position
onready var map = $"../../../Char".map # relative path, but contained within this tscn
onready var path = $"../../PlayerControlledPath"

func _ready():
	set_enabled(false)

func _input(event):
	if enabled:
		if event.is_action("move_up"):
			move_one_cell(Vector2.UP)
		if event.is_action("move_right"):
			print('move right')
			move_one_cell(Vector2.RIGHT)
		if event.is_action("move_down"):
			move_one_cell(Vector2.DOWN)
		if event.is_action("move_left"):
			move_one_cell(Vector2.LEFT)

func reset_position():
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
	
	return destination_cell in walkable_cells
