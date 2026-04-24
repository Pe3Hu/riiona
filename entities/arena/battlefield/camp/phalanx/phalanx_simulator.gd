class_name PhalanxSimulator
extends Resource


var camp: CampSimulator
var spots: Array[SpotSimulator]

var index: int


func _init(camp_: CampSimulator, index_: int) -> void:
	camp = camp_
	index = index_
