class_name LegionResource
extends Resource


var pawn_soldiers: Array[SoldierResource]
var elite_soldiers: Array[SoldierResource]
var battlefield: BattlefieldResource


func _init() -> void:
	init_soldiers()

func init_soldiers() -> void:
	init_pawns()
	init_elites()

func init_pawns() -> void:
	for _i in Catalog.LEGION_PAWN_DEFAULT_COUNT:
		add_soldier(State.Soldier.PAWN)

func init_elites() -> void:
	for _i in Catalog.LEGION_ELITE_DEFAULT_COUNT:
		add_soldier(State.Soldier.ELITE)

func add_soldier(type_: State.Soldier) -> void:
	var initiative = Academy.roll_initiative(type_)
	var soldier = SoldierResource.new(type_, initiative)
	
	match type_:
		State.Soldier.PAWN:
			pawn_soldiers.append(soldier)
		State.Soldier.ELITE:
			elite_soldiers.append(soldier)
