class_name StanceResource
extends Resource


@export var unit: UnitResource
@export var dice: StanceDiceResource


func _init(unit_: UnitResource) -> void:
	unit = unit_
	
	dice = StanceDiceResource.new(unit)
