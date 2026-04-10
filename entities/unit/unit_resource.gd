class_name UnitResource
extends Resource


var health: BowlResource = BowlResource.new(self, State.Bowl.HEALTH)
var guise: GuiseResource = GuiseResource.new(self)
var stance: StanceDiceResource

var type: State.Unit
var initiative: int


func _init(type_: State.Unit) -> void:
	type = type_
	
	stance = StanceDiceResource.new(self)
