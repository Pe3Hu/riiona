class_name TentSimulator
extends Resource


var camp: CampSimulator
var column: ColumnSimulator
var type: State.Soldier
var spawn_spot: SpotSimulator

var index: int

var spawn_soldiers: Array[SoldierSimulator]
var alive_soldiers: Array[SoldierSimulator]


func _init(column_: ColumnSimulator, index_: int) -> void:
	column = column_
	camp = column.camp
	index = index_
	
	type = State.Soldier.PAWN
	
	if index % 2 == 1:
		type = State.Soldier.ELITE

func add_soldier() -> void:
	var initiative = 1
	var soldier = SoldierSimulator.new(self, initiative)
	spawn_soldiers.append(soldier)

func spawn_soldier() -> void:
	var soldier = spawn_soldiers.pop_back()
	soldier.target_spot = spawn_spot
	soldier.machine.state.exit()
