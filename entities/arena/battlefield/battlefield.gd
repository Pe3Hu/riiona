@tool
class_name Battlefield
extends Node2D


signal camp_fallback_finished(camp_: Camp)
signal janitor_finished(janitor_: Janitor)

@onready var soldiers = %Soldiers

@export var camps: Array[Camp]
@export var vanguard: Vanguard

var is_selection_phase: bool = true

var active_camps: Array[Camp]


func _ready() -> void:
	soldiers_motion_simulation()
	is_selection_phase = false

func soldiers_motion_simulation() -> void:
	if is_selection_phase:
		await get_tree().create_timer(1.5).timeout
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
		fill_vanduard()
