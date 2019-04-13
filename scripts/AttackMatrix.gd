extends Object # only needed for get_script()

enum ELEMENTS { HITBOX, ATTACKER, EMPTY } # the elements within an attack matrix
const INT_TO_ELEMENTS_MAPPING = [ELEMENTS.EMPTY, ELEMENTS.ATTACKER, ELEMENTS.HITBOX] # allows for creation of matrix using list of ints instead of list of ELEMENTS values

var matrix = []
var row_len = null
var attacker_coords = [0, 0]


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
		
		if tile_value == ELEMENTS.ATTACKER:
			attacker_coords = [col_count, row_count]
		
		if count % row_len == 0:
			matrix.append(row)
			row = []
			row_count += 1
		else:
			col_count += 1
			
	return matrix
	

# in-place rotation of the matrix
func rotate(radians):
	var rotated = matrix
	
	# Consider all squares one by one 
	for x in range(int(row_len / 2)): 
		for y in range(x, row_len - x - 1): 
		  
			# store current cell in temp variable 
			var temp = rotated[x][y] 
			  
			# move values from right to top 
			rotated[x][y] = rotated[y][row_len-1-x] 
			  
			# move values from bottom to right 
			rotated[y][row_len-1-x] = rotated[row_len-1-x][row_len-1-y] 
			  
			# move values from left to bottom 
			rotated[row_len-1-x][row_len-1-y] = rotated[row_len-1-y][x] 
			  
			# assign temp to left 
			rotated[row_len-1-y][x] = temp 

	var elements = to_elements(rotated)
	return get_script().new(elements) # return new instance of this class


# flatten and make elements of type int
func to_elements(matrix):
	var elements = []
	
	for row in matrix:
		for element in row:
			elements.append(int(element))
			
	return elements


func to_relative_coords():
	var coords = []
	
	for y in range(len(matrix)):
		for x in range(len(matrix[y])):
			if matrix[y][x] == ELEMENTS.HITBOX:
				coords.append([x - attacker_coords[0], attacker_coords[1] - y])
				
	return coords
	
	
	
func to_world_coords(attacker_coords):
	var relative_coords = to_relative_coords()
	
	for coords in relative_coords:
		coords[0] += attacker_coords[0]
		coords[1] += attacker_coords[1]
		
	return relative_coords