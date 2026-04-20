@tool
class_name Phalanx
extends Node2D


@export var camp: Camp
@export var type: State.Phalanx:
	set(value_):
		type = value_
		update_spots()

@export var spots: Array[Spot]


func _ready():
	update_spots()

func update_spots() -> void:
	if !spots: return
	var offset = Catalog.phalanx_to_offset[type] * 2
	
	if type == State.Phalanx.GAP:
		offset += Catalog.phalanx_to_offset[type] / 4
	
	for _i in spots.size():
		var spot = spots[_i]
		spot.position = offset - _i * Catalog.phalanx_to_offset[type]
