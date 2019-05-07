extends Timer

signal timer_ended()

export(float) var time_per_turn = 6
var time_remaining = time_per_turn
onready var Finder = get_node("/root/ObjectFinder")
onready var action_queue_manager = Finder.get_node_from_root("Root/ActionQueueManager")

func _ready():
	action_queue_manager.connect("all_action_queues_finished_executing", self, "_on_ActionQueueManager_all_action_queues_finished_executing")
	
func reset_timer():
	stop()
	time_remaining = time_per_turn
	
# override
func start(time_sec = -1):
	$"../TurnChangeRect".play_animation("Turn Began")
	.start(time_sec)
	
# override
func stop():
	$"../TurnChangeRect".play_animation("Turn Ended")
	.stop()

func _on_TurnTimer_timeout(): # 1 second tick from timer
	time_remaining = clamp(time_remaining - wait_time, 0, INF)
	if time_remaining <= 0: # the turn ends 
		reset_timer()
		# emit signal to call end_turn which executes all agents action queues
		emit_signal("timer_ended") # user didn't manually end turn, 

func _unhandled_input(event):
	if Input.is_action_just_pressed("pause"):
		set_paused(!paused)

func _on_TurnManager_begin_action_queues_execution():
	reset_timer()
