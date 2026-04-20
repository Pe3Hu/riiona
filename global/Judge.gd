extends Node


func _init() -> void:
	#test_duel()
	pass


func test_duel() -> void:
	var soldiers: Array[SoldierResource]
	soldiers.append(SoldierResource.new(State.Soldier.ELITE, 0))
	soldiers.append(SoldierResource.new(State.Soldier.ELITE, 0))
	prepare_duel(soldiers)
	resolve_duel(soldiers)
	#print([values, Catalog.combo_to_string[combo]])


func prepare_duel(soldiers_: Array[SoldierResource]) -> void:
	for soldier in soldiers_:
		soldier.stance.roll()
		soldier.impulse.roll()

func resolve_duel(soldiers_: Array[SoldierResource]) -> void:
	var damage = soldiers_.front().impulse.current_face - soldiers_.back().impulse.current_face
	if damage == 0: return
	
	var victim: SoldierResource = soldiers_.back()
	
	if damage < 0:
		damage = abs(damage)
		victim = soldiers_.front()
	
	victim.take_damage(damage)

func test_resolve_duel(soldiers_: Array[Soldier], values_: Array[int]) -> bool:
	var damage = values_.front() - values_.back()
	if damage == 0: return true
	
	var victim: Soldier = soldiers_.back()
	
	if damage < 0:
		damage = abs(damage)
		victim = soldiers_.front()
	
	victim.take_damage(damage)
	victim.duel_lost()
	return false
