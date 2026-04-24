class_name ColumnSimulator
extends Resource


var camp: CampSimulator
var tent: TentSimulator
var spots: Array[SpotSimulator]

var index: int

func _init(camp_: CampSimulator, index_: int) -> void:
	camp = camp_
	index = index_
	
	tent = TentSimulator.new(self, index)
