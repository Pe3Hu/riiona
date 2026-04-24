class_name BattlefieldSimulator
extends Resource


var arena: ArenaSimulator
var machine: BattlefieldMachine
var id: int = 0

var camps: Array[CampSimulator]
var side_to_camp: Dictionary

var in_process: Array


func _init() -> void:
	init_camps()
	init_vanguard()
	
	machine = BattlefieldMachine.new(self)

func init_camps() -> void:
	for side in Catalog.sides:
		add_side(side)

func add_side(side_: State.Side) -> void:
	var camp = CampSimulator.new(self, side_)
	camps.append(camp)
	side_to_camp[side_] = camp

func init_soldiers() -> void:
	for camp in camps:
		camp.init_soldiers()

func init_vanguard() -> void:
	pass

func finish_process(simulator_: Variant) -> void:
	in_process.erase(simulator_)
	
	if in_process.is_empty():
		machine.state.exit()
