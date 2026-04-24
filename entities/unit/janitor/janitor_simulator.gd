class_name JanitorSimulator
extends Resource


var graveyard: GraveyardSimulator
var machine: JanitorMachine = JanitorMachine.new(self)


func _init(graveyard_: GraveyardSimulator) -> void:
	graveyard = graveyard_
