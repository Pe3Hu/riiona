class_name StanceSimulator
extends Resource


@export var soldier: SoldierSimulator
@export var dice: StanceDiceSimulator


func _init(soldier_: SoldierSimulator) -> void:
	soldier = soldier_
	
	dice = StanceDiceSimulator.new(soldier)
