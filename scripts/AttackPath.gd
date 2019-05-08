extends Path2D

onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")
var AttackAction = load("res://scripts/AgentActionSystem/AttackAction.gd")
var DIRECTIONS = { 'up': 0, 'right': 90, 'down': 180, 'left': 270 }

onready var attacks = {attack_template.MODE.SLASH:load("res://paths/SlashCurve.tres"),attack_template.MODE.SWING:load("res://paths/SwingCurve.tres"),attack_template.MODE.LUNGE:load("res://paths/LungeCurve.tres"),attack_template.MODE.BITE:load("res://paths/BiteCurve.tres")}

var playing = false

func switch_out_sprite_to(var sprite, var scale):
	$'PathFollow2D/Sword'.texture = sprite
	$'PathFollow2D/Sword'.scale = scale

func _ready():
	visible = false
	
func play_action(var action):
	if action is AttackAction:
		var mode = action.attack_mode
		var dir_str = action.direction_str
		if attacks.has(mode):
			play_effect(attacks.get(mode), get_rot_deg(dir_str))
			
func get_rot_deg(var dir_str):
	return DIRECTIONS.get(dir_str)
	
func play_effect(var path, var rot):
	curve = path
	rotation_degrees = rot
	$PathFollow2D.unit_offset = 0
	visible = true
	playing = true

func _process(delta):
	if playing:
		$PathFollow2D.unit_offset += delta
		if $PathFollow2D.unit_offset >= 1:
			$PathFollow2D.unit_offset = 0
			rotation_degrees = 0
			playing = false
			visible = false