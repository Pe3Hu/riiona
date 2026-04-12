class_name LegionResource
extends Resource


var pawn_units: Array[UnitResource]
var elite_units: Array[UnitResource]
var battlefield: BattlefieldResource


func _init() -> void:
	init_units()

func init_units() -> void:
	init_pawns()
	init_elites()

func init_pawns() -> void:
	for _i in Catalog.LEGION_PAWN_DEFAULT_COUNT:
		add_unit(State.Unit.PAWN)

func init_elites() -> void:
	for _i in Catalog.LEGION_ELITE_DEFAULT_COUNT:
		add_unit(State.Unit.ELITE)

func add_unit(type_: State.Unit) -> void:
	var initiative = Academy.roll_initiative(type_)
	var unit = UnitResource.new(type_, initiative)
	
	match type_:
		State.Unit.PAWN:
			pawn_units.append(unit)
		State.Unit.ELITE:
			elite_units.append(unit)
