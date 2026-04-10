class_name UnitResource
extends Resource


var health: BowlResource = BowlResource.new(self, State.Bowl.HEALTH)
var guise: GuiseResource = GuiseResource.new(self)

var stance: StanceDiceResource
var impulse: ImpulseDiceResource

var type: State.Unit
var initiative: int
var mastery: int = 1


func _init(type_: State.Unit, initiative_: int) -> void:
	type = type_
	initiative = initiative_
	
	stance = StanceDiceResource.new(self)

func take_damage(damage_: int) -> void:
	health.change_value(-damage_)
