func get_name(obj_or_str):
	match typeof(obj_or_str):
		TYPE_STRING: 
			return obj_or_str
		TYPE_OBJECT:
			return obj_or_str.get_name()
			
	print_debug("unknown obj type")
