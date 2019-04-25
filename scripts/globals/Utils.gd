static func get_name(obj_or_str):
	if obj_or_str == null: return "null"
	
	match typeof(obj_or_str):
		TYPE_STRING: 
			return obj_or_str
		TYPE_OBJECT:
			return obj_or_str.get_name()
			
	print_debug("unknown obj type")

# element-wise clamp
static func vector2_clamp(vector: Vector2, min_value: Vector2, max_value: Vector2): 
	var new_vector = vector
	
	if vector.x < min_value.x:
		new_vector.x = min_value.x
	elif vector.x > max_value.x:
		new_vector.x = max_value.x
		
	if vector.y < min_value.y:
		new_vector.y = min_value.y
	elif vector.y > max_value.y:
		new_vector.y = max_value.y
	
	return new_vector