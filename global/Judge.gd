extends Node


func _init() -> void:
	test_duel()
	pass


func test_duel() -> void:
	var units: Array[UnitResource]
	units.append(UnitResource.new(State.Unit.ELITE, 0))
	units.append(UnitResource.new(State.Unit.ELITE, 0))
	prepare_duel(units)
	resolve_duel(units)
	#print([values, Catalog.combo_to_string[combo]])


func prepare_duel(units_: Array[UnitResource]) -> void:
	for unit in units_:
		unit.stance.roll()
		unit.impulse.roll()

func resolve_duel(units_: Array[UnitResource]) -> void:
	var damage = units_.front().impulse.current_face - units_.back().impulse.current_face
	if damage == 0: return
	
	var victim: UnitResource = units_.back()
	
	if damage < 0:
		damage = abs(damage)
		victim = units_.front()
	
	victim.take_damage(damage)
