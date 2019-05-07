extends Sprite

var MoveAction = load("res://scripts/AgentActionSystem/MoveAction.gd")

var enabled = false

onready var Finder = get_node("/root/ObjectFinder") # Finder global
onready var agent = $"../"
onready var map = Finder.get_node_from_root("Root/Map")
onready var path = $"../PlayerControlledPath"
onready var action_queue = $"../ActionQueue"


func _ready():
	set_enabled(false)

# Movement input is now handled by PlayerInputManager
#func _input(event):
	

func reset_position():
	position = Vector2() # position is relative; (0, 0) is on parent

# param dir: unit vector for direction (Vector2.RIGHT, Vector2.LEFT, etc)
func move_one_cell(direction: Vector2):
	var next_pos = agent.position + position + direction * map.cell_size # position where agent would move
	if is_walkable(next_pos):
		position = next_pos - agent.position # position of this sprite (relative to where agent currently is)
		agent.queue_move_action(direction) # add to action queue

func undo_one_move(direction: Vector2):
	var next_pos = agent.position + position - direction * map.cell_size # position where agent would move
	position = next_pos - agent.position # position of this sprite (relative to where agent currently is)
	path.draw_walkable(path.get_target_grid_pos())
	set_enabled(true)
	
# set visibility and reset position
func set_enabled(enabled):
	self.enabled = enabled
	visible = enabled

func is_walkable(next_position):
	# don't allow moving out of bounds
	# don't allow moving outside of agent movable tiles
	var walkable_cells = path.get_agent_walkable_cell_coords()
	var destination_cell = map.world_to_mapa(next_position)

	return destination_cell in walkable_cells

func get_cell_coords():
	return map.world_to_map(position)