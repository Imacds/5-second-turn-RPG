extends TileMap

export(Vector2) var area_of_movement = Vector2(5, 5)

onready var tile_size = cell_size
onready var half_tile_size = tile_size / 2

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
