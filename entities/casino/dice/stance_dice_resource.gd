class_name StanceDiceResource
extends DiceResource


var unit: UnitResource


func _init(unit_: UnitResource) -> void:
	unit = unit_
	super._init()
	
	init_faces()

func init_faces() -> void:
	faces.append_array(Catalog.defaul_actions)
	
	match unit.type:
		pass
