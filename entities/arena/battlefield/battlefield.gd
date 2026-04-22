@tool
class_name Battlefield
extends Node2D

@warning_ignore("unused_signal")
#signal camp_fallback_finished(camp_: Camp)
signal janitor_finished(janitor_: Janitor)
@warning_ignore("unused_signal")
signal camp_march_finished(camp_: Camp)

@onready var soldiers = %Soldiers
@onready var left_camp = %LeftCamp
@onready var right_camp = %RihgtCamp

@export var camps: Array[Camp]
@export var vanguard: Vanguard

var is_selection_phase: bool = true

var active_camps: Array[Camp]


func _ready() -> void:
	right_camp.graveyard.update_texture()
	#soldiers_motion_simulation()

func soldiers_motion_simulation() -> void:
	if is_selection_phase:
		await get_tree().create_timer(1.8).timeout
		is_selection_phase = false
	
	fill_vanduard()
	#await get_tree().create_timer(0.9).timeout
	#roster_shuffle()

func _on_ready_button_pressed() -> void:
	soldiers_motion_simulation()

func fill_vanduard() -> void:
	for camp in camps:
		camp.update_soldier_target_spots()

func roster_shuffle() -> void:
	for camp in camps:
		camp.roster_shuffle()

func _on_janitor_finished(janitor_: Janitor) -> void:
	active_camps.erase(janitor_.graveyard.camp)
	
	if active_camps.is_empty():
		for camp in camps:
			camp.reset_duels()
		
		fill_vanduard()

func winner_determination() -> void:
	%VictoryLabel.visible = true

func _on_camp_march_finished(camp_: Camp) -> void:
	active_camps.erase(camp_)
	
	if active_camps.is_empty():
		prepare_duels()

func prepare_duels() -> void:
	for camp in camps:
		var phalanx = camp.phalanxs.front()
		phalanx.distribute_incomplete_spots()
