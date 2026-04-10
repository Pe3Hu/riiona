class_name BowlResource
extends Resource


@export var unit: UnitResource
@export var type: State.Bowl

@export var current_value: int
@export var max_value: int
@export var min_value: int = 0


func _init(unit_: UnitResource, type_: State.Bowl) -> void:
	unit = unit_
	type = type_
