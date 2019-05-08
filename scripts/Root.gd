extends Node

export(float) var intro_banner_animation_speed = 0.2

var SceneManager

onready var SMRT = get_node("DialogBox")
var dialog_box_counter = 0

func _enter_tree():
	SceneManager = get_node("/root/SceneManager")
	SceneManager.setup_scene(self, get_node("Map"))

func _ready():
	$"TurnManager/TurnTimer".set_paused(true)
	$LargeNotifyBanner.set_animation_speed(intro_banner_animation_speed)
	$LargeNotifyBanner.play_animation(SceneManager.scene_name) # flash that banner with text like "Level 1"
	$"LargeNotifyBanner/AnimationPlayer".connect("animation_finished", self, "_on_LargeNotifyBanner_animation_finished")

func dialog_box():
	SMRT.on_dialog = true
	ProjectSettings.set("money", 1000)
	if Input.is_key_pressed(KEY_0):
		SMRT.show_text("Beginning", "Say Something", dialog_box_counter)
		dialog_box_counter += 1
		
func _on_LargeNotifyBanner_animation_finished(anim_name):
	$"TurnManager/TurnTimer".set_paused(false)