class_name GuiseResource
extends Resource


@export var unit: UnitResource

@export var hair: State.Hair
@export var eye: State.Eye


func _init(unit_: UnitResource) -> void:
	unit = unit_
	
	roll_hair()
	roll_eye()

func roll_hair() -> void:
	hair = Catalog.eye_options.pick_random()

func roll_eye() -> void:
	eye = Catalog.eye_options.pick_random()
