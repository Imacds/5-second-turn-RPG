extends Object # only needed for get_script()

enum ELEMENTS { EMPTY, ATTACKER, HITBOX, ATTACKER_AND_HITBOX } # the elements within an attack matrix
const INT_TO_ELEMENTS_MAPPING = [ELEMENTS.EMPTY, ELEMENTS.ATTACKER, ELEMENTS.HITBOX, ELEMENTS.ATTACKER_AND_HITBOX] # allows for creation of matrix using list of ints instead of list of ELEMENTS values

var matrix = []
var row_len = null
var attacker_coords = null # list of size = 2, map.grid indices (cell coords)


func _init(elements):
	row_len = int(sqrt(len(elements)))
	matrix = elements_to_matrix(elements)
		

# create an N x N matrix where N = |elements|
# param elements: list of values of type int, see mapping in var INT_TO_ELEMENTS_MAPPING
func elements_to_matrix(elements):
	var count = 0
	var row_count = 1
	var col_count = 1
	var row = []
	var matrix = []

	for element in elements:
		count += 1
		
		var tile_value = INT_TO_ELEMENTS_MAPPING[element]
		row.append(tile_value)
		
		if tile_value == ELEMENTS.ATTACKER || tile_value == ELEMENTS.ATTACKER_AND_HITBOX:
			#if attacker_coords != null: print_debug("there's 2+ attackers in atk matrix")
			attacker_coords = [col_count - 1, row_count - 1]
		
		if count % row_len == 0:
			matrix.append(row)
			row = []
			row_count += 1
			col_count = 1
		else:
			col_count += 1
	
	#if attacker_coords == null: print_debug("there was not an attacker within the atk matrix")
	return matrix
	

# in-place rotation of the matrix
func rotate(rot): 
	var rotated = matrix.duplicate(true)
	
	# Consider all squares one by one 
	for x in range(0, len(rotated)): 
		for y in range(0, len(rotated[0])): 
			if rot == 0:
				rotated[x][y] = matrix[x][y]
			elif rot == 90:
				rotated[x][y] = matrix[len(rotated[0])-y-1][x]
			elif rot == 180:
				rotated[x][y] = matrix[len(rotated)-x-1][len(rotated[0])-y-1]
			elif rot == 270:
				rotated[x][y] = matrix[y][len(rotated)-x-1]
			else:
				print_debug("An illegal value has been given to AttackMatrix.rotate(): " + rot)
	
	var elements = to_elements(rotated)
	return get_script().new(elements) # return new instance of this class


# flatten and make elements of type int that rep. matrix elements
func to_elements(matrix):
	var elements = []
	
	for row in matrix:
		for element in row:
			elements.append(int(element))
			
	return elements


func to_relative_coords():
	var coords = []
	
	#center it around the char
	var size = int(len(matrix)/2)
	
	for y in range(len(matrix)):
		for x in range(len(matrix[y])):
			if matrix[y][x] == ELEMENTS.HITBOX or matrix[y][x] == ELEMENTS.ATTACKER_AND_HITBOX:
				coords.append([x - size, y - size])
				
	return coords
	

# param attack_coords:
func to_world_coords(attack_coords, constraint: FuncRef = null, agent = null):
	var relative_coords = to_relative_coords()
	var cell_coords = []
	var enable_filter = constraint
	var attack_coords_array = [attack_coords[0], attack_coords[1]]
    
	for coords in relative_coords:
		coords[0] += attack_coords[0]
		coords[1] += attack_coords[1]
        
		# Map.gd constraint args: cell_start: Array, cell_destination: Array, distance_limit = 3
		if not enable_filter or (enable_filter and constraint.call_func(attack_coords_array, coords, agent)):
			cell_coords.append(coords)
            
	return cell_coords
	
func to_str():
	var repr = ""
	var size = len(matrix) - 1
	
	for j in range(len(matrix)):
		for i in range(len(matrix)):
			repr += str(matrix[j][i]) + " "
		repr += "\n"
			
	return repr
	