class_name DiceResource
extends Resource


@export var faces: Array


func _init() -> void:
	pass


func roll() -> Variant:
	faces.shuffle()
	var result = faces.back()
	return result
