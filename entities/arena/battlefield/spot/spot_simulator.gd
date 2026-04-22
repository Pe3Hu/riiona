class_name SpotSimulator
extends Resource


var camp: CampSimulator
var column: ColumnSimulator
var phalanx: PhalanxSimulator
var soldier: SoldierSimulator

var grid: Vector2i


func _init(camp_: CampSimulator, grid_: Vector2i) -> void:
	camp = camp_
	grid = grid_
