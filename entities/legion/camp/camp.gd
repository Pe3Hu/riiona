@tool
class_name Camp
extends Node2D


@export var battlefield: Battlefield
@export var side: State.Side
@export var current_spawn_phalanx: Phalanx

#@onready var markes = %Markers
@onready var phalanxs = %Phalanxs
@onready var tents = %Tents
@onready var tent_timer = %TentTimer


func _ready() -> void:
	pass

#func get_tent() -> Tent:
	#var tent = tents.get_child(index_)


func _on_tent_timer_timeout() -> void:
	for tent in tents.get_children():
		tent.swapn_unit()
	
	update_spawn_phalanx()

func update_spawn_phalanx() -> void:
	var phalanx_index = current_spawn_phalanx.get_index() + 1
	
	if phalanx_index == phalanxs.get_child_count():
		tent_timer.stop()
		current_spawn_phalanx = null
		return
	
	current_spawn_phalanx = phalanxs.get_child(phalanx_index)
