class_name BattleSimulator
extends Resource


var arena: ArenaSimulator
var id: int = 0
var phase: State.Phase = State.Phase.START
var camps: Array[Camp]
var side_to_camp: Dictionary


func _init() -> void:
	init_camps()
	init_vanguard()

func init_camps() -> void:
	for side in Catalog.SIDES:
		add_side(side)

func add_side(side_: State.Side) -> void:
	var camp = CampSimulator.new(self, side_)
	camps.append(camp)
	side_to_camp[side_] = camp

func init_vanguard() -> void:
	pass
