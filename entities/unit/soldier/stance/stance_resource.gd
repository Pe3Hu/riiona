class_name StanceResource
extends Resource


@export var soldier: SoldierResource
@export var dice: StanceDiceResource


func _init(soldier_: SoldierResource) -> void:
	soldier = soldier_
	
	dice = StanceDiceResource.new(soldier)
