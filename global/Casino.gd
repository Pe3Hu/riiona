extends Node



func _init() -> void:
	#test_poker()
	pass

func test_poker() -> void:
	var values = [0, 0, 1, 2, 0]
	var combo = detect_poker_combo(values)
	print([values, Catalog.combo_to_string[combo]])

func detect_poker_combo(values_: Array) -> State.PokerCombo:
	var value_to_count: Dictionary
	var max_count = 0
	
	for value in values_:
		if !value_to_count.has(value):
			value_to_count[value] = 0
		
		value_to_count[value] += 1
		
		if value_to_count[value] > max_count:
			max_count = value_to_count[value]
	
	if is_straight(value_to_count):
		return State.PokerCombo.STRAIGHT
	
	var keys = value_to_count.keys()
	
	for value in keys:
		if value_to_count[value] == 1:
			value_to_count.erase(value)
	
	
	match value_to_count.keys().size():
		1:
			match max_count:
				2:
					return State.PokerCombo.DOUBLE
				3:
					return State.PokerCombo.TRIPLET
		2:
			match max_count:
				2:
					return State.PokerCombo.DOUBLE_DOUBLE
				3:
					return State.PokerCombo.DOUBLE_TRIPLET
	
	return State.PokerCombo.NONE

func is_straight(value_to_count_: Dictionary) -> bool:
	if value_to_count_.size() != Catalog.POKER_SIZE: return false
	var values = value_to_count_.keys()
	values.sort()
	
	for _i in range(0, values.size() - 2, 1):
		if values[_i] + 1 != values[_i + 1]:
			return false
	
	return true
