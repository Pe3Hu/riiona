class_name CampSimulator
extends Resource


var battlefied: BattleSimulator
var side: State.Side

var columns: Array[ColumnSimulator]
var phalanxs: Array[PhalanxSimulator]
var tents: Array[Tent]
var graveyard: GraveyardSimulator


func _init(battlefied_: BattleSimulator, side_: State.Side) -> void:
	battlefied = battlefied_
	side = side_
	
	init_spots()
	graveyard = GraveyardSimulator.new(self)

func init_spots() -> void:
	for _i in Catalog.CAMP_COLUMN_DEFAULT_COUNT:
		add_column(_i)
	
	for _i in Catalog.CAMP_PHALANX_DEFAULT_COUNT:
		add_phalanx(_i)
	
	for _i in Catalog.CAMP_PHALANX_DEFAULT_COUNT:
		for _j in Catalog.CAMP_PHALANX_DEFAULT_COUNT:
			var grid = Vector2i(_j, _i)
			add_spot(grid)

func add_column(index_: int) -> void:
	var column = ColumnSimulator.new(self, index_)
	columns.append(column)
	tents.append(column.tent)

func add_phalanx(index_: int) -> void:
	var phalanx = PhalanxSimulator.new(self, index_)
	phalanxs.append(phalanx)

func add_spot(grid_: Vector2i) -> void:
	var spot = SpotSimulator.new(self, grid_)
	spot.column = columns[grid_.y]
	spot.column.spots.append(spot)
	spot.phalanx = phalanxs[grid_.y]
	spot.phalanx.spots.append(spot)
