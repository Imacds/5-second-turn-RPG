extends Node

onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")

func _ready():
	var set_sounds = [load("res://sfx/rat_step.wav"),load("res://sfx/rat_damaged.wav"),load("res://sfx/rat_death.wav"),{attack_template.MODE.BITE:load("res://sfx/rat_attack.wav")}]
	$'Char/CharSounds'.set_sounds(set_sounds)
	$'Char/AttackPath'.switch_out_sprite_to(load("res://sprites/source/Claw.png"), Vector2(1,1))