class_name CampSimulator
extends Resource


var battlefied: BattlefieldSimulator
var side: State.Side

var columns: Array[ColumnSimulator]
var phalanxs: Array[PhalanxSimulator]
var tents: Array[TentSimulator]
var graveyard: GraveyardSimulator

var in_process: Array


func _init(battlefied_: BattlefieldSimulator, side_: State.Side) -> void:
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
	spot.phalanx = phalanxs[grid_.x]
	spot.phalanx.spots.append(spot)
	
	if grid_.x == Catalog.CAMP_PHALANX_DEFAULT_COUNT - 1:
		spot.column.tent.spawn_spot = spot

func init_soldiers() -> void:
	for tent in tents:
		in_process.append(tent)
		
		for _i in 1:
			tent.add_soldier()
	
	spawn_soldiers()
	
func spawn_soldiers() -> void:
	for tent in tents:
		if tent.spawn_soldiers.is_empty():
			finish_process(tent)
		else:
			tent.spawn_soldier()

func finish_process(simulator_: Variant) -> void:
	in_process.erase(simulator_)
	
	if in_process.is_empty():
		battlefied.finish_process(self)

#func process_soldier_movement(soldier_: SoldierSimulator) -> void:
	#pass
