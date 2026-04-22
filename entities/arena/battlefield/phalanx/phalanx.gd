@tool
class_name Phalanx
extends Node2D


#signal soldier_joined(soldier_: Soldier)

@export var camp: Camp
@export var type: State.Phalanx:
	set(value_):
		type = value_
		update_spots()

@export var spots: Array[Spot]

@export var index: int


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

func distribute_incomplete_spots() -> void:
	camp.last_march_solider = null
	var soldier_spots: Array[Spot]
	var distance_to_spots: Dictionary
	var spot_to_distance: Dictionary
	var center_index: int = spots[int(Catalog.VANGUARD_DUEL_DEFAULT_COUNT / 2)].index
	var empty_spots: Array
	empty_spots.append_array(spots)
	
	for spot in spots:
		if spot.soldier:
			var distance = abs(spot.index - center_index)
			
			if !distance_to_spots.has(distance):
				distance_to_spots[distance] = []
			
			distance_to_spots[distance].append(spot)
			spot_to_distance[spot] = distance
			soldier_spots.append(spot)
	
	var incomplete_count = abs(soldier_spots.size() - Catalog.VANGUARD_DUEL_DEFAULT_COUNT)
	
	if incomplete_count <= 1: return
	var target_spots: Array[Spot]
	#target_spots.append(spots[center_index])
	
	soldier_spots.sort_custom(func(a, b): return spot_to_distance[a] < spot_to_distance[b])
	
	if soldier_spots.size() == 3 and distance_to_spots.keys().size() == 3:
		single_shift(soldier_spots)
		return
	
	while !soldier_spots.is_empty():
		var options = []
		
		for spot in soldier_spots:
			if spot_to_distance[spot] == spot_to_distance[soldier_spots.front()]:
				options.append(spot)
		
		var spot = options.pick_random()
		soldier_spots.erase(spot)
		distance_to_spots[spot_to_distance[spot]].erase(spot)
		var shift_direction = center_index - spot.index
		
		if shift_direction == 0: continue
		
		spot.soldier.target_spot = spots[spot.index + shift_direction - 1]
	

func single_shift(spots_: Array[Spot]) -> void:
	var center_index: int = spots[int(Catalog.VANGUARD_DUEL_DEFAULT_COUNT / 2)].index
	var shift_direction = center_index - spots_.back().index
	
	for spot in spots_:
		spot.soldier.target_spot = spots[spot.index + shift_direction - 1]


#func _on_soldier_joined(soldier_: Soldier) -> void:
	#if index != 1: return
	#
	#if !camp.is_march:
		#pass
