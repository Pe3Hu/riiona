@tool
class_name Vanguard
extends Node2D


signal duel_finished(duel_: Duel)
signal duel_canceled(duel_: Duel)

@export var battlefield: Battlefield
@export var offset: int = 176:
	set(value_):
		offset = value_
		
		update_duel_positions()

@export var duels: Array[Duel] = []

var active_duels: Array[Duel]
var cancel_duels: Array[Duel]


func _ready() -> void:
	update_duel_spots()

func update_duel_spots() -> void:
	var left_phalanx = battlefield.camps[0].phalanxs.front()
	var right_phalanx = battlefield.camps[1].phalanxs.front()
	
	for duel in duels:
		var spot = left_phalanx.spots[duel.index - 1]
		duel.spots.append(spot)
		spot.pool = duel.left_pool
		duel.left_pool.spot = spot
		spot = right_phalanx.spots[duel.index - 1]
		duel.spots.append(spot)
		spot.pool = duel.right_pool
		duel.right_pool.spot = spot

func update_duel_positions() -> void:
	for _i in duels.size():
		var duel = duels[_i]
		duel.position.y = offset * (-2 + _i)

func _on_duel_finished(duel_: Duel) -> void:
	active_duels.erase(duel_)
	
	if active_duels.is_empty():
		battlefield.roster_shuffle()

func _on_duel_canceled(duel_: Duel) -> void:
	cancel_duels.append(duel_)
	
	if cancel_duels.size() == Catalog.VANGUARD_DUEL_DEFAULT_COUNT:
		battlefield.winner_determination()
