class_name GuiseSimulator
extends Resource


@export var unit: SoldierSimulator

@export var hair: State.Hair
@export var eye: State.Eye


func _init(unit_: SoldierSimulator) -> void:
	unit = unit_
	
	roll_hair()
	roll_eye()

func roll_hair() -> void:
	hair = Catalog.eye_options.pick_random()

func roll_eye() -> void:
	eye = Catalog.eye_options.pick_random()
