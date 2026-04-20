class_name BowlResource
extends Resource


@export var unit: SoldierResource
@export var type: State.Bowl

@export var current_value: int
@export var max_value: int
@export var min_value: int = 0


func _init(unit_: SoldierResource, type_: State.Bowl) -> void:
	unit = unit_
	type = type_


func change_value(value_: int) -> void:
	current_value += value_
	
	if value_ > 0:
		current_value = min(current_value, max_value)
	else:
		current_value = max(current_value, min_value)
