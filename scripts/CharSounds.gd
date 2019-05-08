extends AudioStreamPlayer2D

onready var attack_template = get_tree().get_root().get_node("Root/AttackTemplate")

var MoveAction = load("res://scripts/AgentActionSystem/MoveAction.gd")
var AttackAction = load("res://scripts/AgentActionSystem/AttackAction.gd")
var WaitAction = load("res://scripts/AgentActionSystem/WaitAction.gd")

onready var sound_walking = load("res://sfx/generic_step.wav")
onready var sound_damaged = load("res://sfx/generic_damaged.wav")
onready var sound_death = load("res://sfx/generic_death.wav")
onready var sounds_attack = {attack_template.MODE.SLASH:load("res://sfx/generic_slash.wav"),attack_template.MODE.SWING:load("res://sfx/generic_swing.wav"),attack_template.MODE.LUNGE:load("res://sfx/generic_lunge.wav")}

func set_sounds(var array):
	if array == null:
		return
	
	sound_walking = array[0]
	sound_damaged = array[1]
	sound_death = array[2]
	sounds_attack = array[3]

func play_effect(var effect):
	stream = effect
	play()

func play_corresponding_sound(var action):
	if action is MoveAction:
		play_effect(sound_walking)
	elif action is AttackAction:
		var mode = action.attack_mode
		if sounds_attack.has(mode):
			play_effect(sounds_attack.get(mode))

func _on_CharSounds_finished():
	pass