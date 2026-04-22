class_name TentSimulator
extends Resource


var camp: CampSimulator
var column: ColumnSimulator

var index: int

var spawn_soldiers: Array[SoldierResource]
var alive_soldiers: Array[SoldierResource]


func _init(column_: ColumnSimulator, index_: int) -> void:
	column = column_
	camp = column.camp
	index = index_
