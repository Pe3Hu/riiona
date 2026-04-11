class_name Battlefield
extends Node2D


@onready var unit = %Unit


func _ready() -> void:
	pass


func move_unit(target: Vector2) -> void:
	unit.move_to(target)


#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("click"):
		#var target_position = get_global_mouse_position()
		#move_unit(target_position)
