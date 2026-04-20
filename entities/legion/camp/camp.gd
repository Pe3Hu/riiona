@tool
class_name Camp
extends Node2D


signal fallback_finished(fallback_: Fallback)


@export var battlefield: Battlefield
@export var side: State.Side:
	set(value_):
		if side != value_:
			switch_side()
		
		side = value_

@export var current_spawn_phalanx: Phalanx

@export var fallbacks: Array[Fallback]
@export var phalanxs: Array[Phalanx]
@export var tents: Array[Tent]
@export var graveyard: Graveyard

@onready var tent_timer = %TentTimer

var soldiers: Array[Soldier]
var active_fallbacks: Array[Fallback]


func _ready() -> void:
	init_fallback_spots()

#func get_tent() -> Tent:
	#var tent = tents.get_child(index_)

func _on_tent_timer_timeout() -> void:
	for tent in tents:
		tent.swapn_soldier()
	
	update_spawn_phalanx()

func update_spawn_phalanx() -> void:
	var phalanx_index = current_spawn_phalanx.get_index() + 1
	
	if phalanx_index == phalanxs.size():
		tent_timer.stop()
		current_spawn_phalanx = null
		return
	
	current_spawn_phalanx = phalanxs[phalanx_index]

func switch_side() -> void:
	#position.x *= -1
	
	#for mark in %Markers.get_children():
		#mark.position.x *= -1 
	
	if phalanxs:
		for phalanx in phalanxs:
			phalanx.position.x *= -1 
	
	if tents:
		%Tents.position.x *= -1 
	
	if fallbacks:
		for fallback in fallbacks:
			fallback.switch_side()

func init_fallback_spots() -> void:
	for _i in fallbacks.size():
		var fallback = fallbacks[_i]
		
		for _j in phalanxs.size():
			var phalanx = phalanxs[_j]
			var spot = phalanx.spots[_i]
			fallback.spots.push_front(spot)

func update_soldier_target_spots() -> void:
	for soldier in soldiers:
		soldier.update_target_spot()

func roster_shuffle() -> void:
	battlefield.active_camps.append(self)
	graveyard.activate()
	
	for fallback in fallbacks:
		fallback.activate()

func _on_fallback_finished(fallback_: Fallback) -> void:
	active_fallbacks.erase(fallback_)
	
	if active_fallbacks.is_empty():
		battlefield.camp_fallback_finished.emit(self)
