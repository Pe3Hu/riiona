class_name DiceResource
extends Resource


@export var faces: Array

@export var current_face: Variant


func _init() -> void:
	pass

func roll() -> Variant:
	#faces.shuffle()
	#current_face = faces.back()
	current_face = faces.pick_random()
	return current_face
