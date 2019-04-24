# abstract class

# game_context is the root node of the scene
func execute():
	print_debug("not implemented in abc")
	
func get_cost():
	print_debug("not implemented in abc")
	
static func can_do_action(action, action_points_available: int) -> bool:
	return action_points_available - action.get_cost() >= 0