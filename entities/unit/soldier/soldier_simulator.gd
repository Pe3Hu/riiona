class_name SoldierSimulator
extends Resource


var health: BowlSimulator = BowlSimulator.new(self, State.Bowl.HEALTH)
var guise: GuiseSimulator = GuiseSimulator.new(self)

var stance: StanceDiceSimulator
var impulse: ImpulseDiceSimulator

var type: State.Soldier
var initiative: int
var mastery: int = 1


func _init(type_: State.Soldier, initiative_: int) -> void:
	type = type_
	initiative = initiative_
	
	stance = StanceDiceSimulator.new(self)

func take_damage(damage_: int) -> void:
	health.change_value(-damage_)
