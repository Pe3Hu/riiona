class_name GraveyardSimulator
extends Resource


var camp: CampSimulator
var janitor: JanitorSimulator = JanitorSimulator.new(self)


func _init(camp_: CampSimulator) -> void:
	camp = camp_
