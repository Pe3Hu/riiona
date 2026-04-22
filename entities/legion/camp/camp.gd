@tool
class_name Camp
extends Node2D


@warning_ignore("unused_signal")
signal column_finished(column_: Column)
@warning_ignore("unused_signal")
signal soldier_joined(soldier_: Soldier)

@export var battlefield: Battlefield
@export var side: State.Side:
	set(value_):
		if side != value_:
			switch_side()
		
		side = value_

@export var current_spawn_phalanx: Phalanx

@export var columns: Array[Column]
@export var phalanxs: Array[Phalanx]
@export var tents: Array[Tent]
@export var graveyard: Graveyard

@onready var tent_timer = %TentTimer

var soldiers: Array[Soldier]
var active_columns: Array[Column]
var empty_duels: Array[Duel]
var vanguard_soldiers: Array[Soldier]

var is_march: bool = true
var last_march_solider: Soldier = null


func _ready() -> void:
	reset_duels()
	init_column_spots()

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
	
	tent_timer.stop()
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
		
		for tent in %Tents.get_children():
			tent.side = Catalog.side_to_side[tent.side]
	
	if columns:
		for column in columns:
			column.switch_side()
	
	if graveyard:
		graveyard.update_texture()

func init_column_spots() -> void:
	for _i in columns.size():
		var column = columns[_i]
		
		for _j in phalanxs.size():
			var phalanx = phalanxs[_j]
			var spot = phalanx.spots[_i]
			column.spots.push_front(spot)
			spot.column = column

func update_soldier_target_spots() -> void:
	for tent in tents:
		if !soldiers.is_empty():
		
			for soldier in soldiers:
				soldier.update_target_spot()

func roster_shuffle() -> void:
	battlefield.active_camps.append(self)
	graveyard.activate()
	last_march_solider = null
	
	for column in columns:
		column.activate()

func _on_column_finished(column_: Column) -> void:
	#active_columns.erase(column_)
	##if active_columns.is_empty():
	#	#pass
	#var duel = column_.spots.back().pool.duel
	#empty_duels.append(duel)
	pass

func _on_soldier_joined(soldier_: Soldier) -> void:
	vanguard_soldiers.append(soldier_)

func reset_duels() -> void:
	empty_duels.clear()
	
	for tent in tents:
		if !tent.soldiers.is_empty():
			var duel = tent.column.spots.back().pool.duel
			empty_duels.append(duel)
