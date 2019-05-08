extends AStar

var do_line_greed = true
var map

#Override
func _estimate_cost(from_id, to_id):
	if do_line_greed:
		#If you are a straight line away from the target, weight it slightly better
		if map.get_x_from_index(from_id) == map.get_x_from_index(to_id) || map.get_y_from_index(from_id) == map.get_y_from_index(to_id):
			return manhaten_dist(from_id, to_id) - 1
		#If you are not a straight line away from the target, weight it normal
		else:
			return manhaten_dist(from_id, to_id)
	else:
		#If you are a straight line away from the target, weight it normal
		if map.get_x_from_index(from_id) == map.get_x_from_index(to_id) || map.get_y_from_index(from_id) == map.get_y_from_index(to_id):
			return manhaten_dist(from_id, to_id)
		#If you are not a straight line away from the target, weight it slightly better
		else:
			return manhaten_dist(from_id, to_id) - 1
			
func manhaten_dist(from,to):
	var dx = abs(map.get_x_from_index(to)-map.get_x_from_index(from))
	var dy = abs(map.get_y_from_index(to)-map.get_y_from_index(from))
	return dx+dy