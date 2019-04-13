extends Node

enum ELEMENTS { HITBOX, ATTACKER, EMPTY } # the elements within an attack matrix
const INT_TO_ELEMENTS_MAPPING = [ELEMENTS.EMPTY, ELEMENTS.ATTACKER, ELEMENTS.HITBOX] # allows for creation of matrix using list of ints instead of list of ELEMENTS values

# create an N x N matrix where N = |elements|
# param elements: list of values of type AttackMatrix.ELEMENTS
func _init(elements):
	var count = 0
	var matrix = []
	var row = []
	var row_len = int(sqrt(len(elements)))
	
	for element in elements:
		count += 1
		row.append(INT_TO_ELEMENTS_MAPPING[element])
		
		if count % row_len == 0:
			matrix.append(row)
			row = []
				