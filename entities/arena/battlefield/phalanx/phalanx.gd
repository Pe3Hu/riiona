@tool
class_name Phalanx
extends Node2D


@export var type: State.Phalanx:
	set(value_):
		type = value_
		update_spots()

@onready var spots = %Spots


func _ready():
	update_spots()

func update_spots() -> void:
	if !spots: return
	var offset = Catalog.phalanx_to_offset[type] * 2
	
	if type == State.Phalanx.GAP:
		offset += Catalog.phalanx_to_offset[type] / 4
	
	for _i in spots.get_child_count():
		var spot = spots.get_child(_i)
		spot.position = offset - _i * Catalog.phalanx_to_offset[type]
