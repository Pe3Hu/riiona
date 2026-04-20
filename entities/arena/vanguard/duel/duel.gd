@tool
class_name Duel
extends Node2D


signal soldier_joined(soldier_: Soldier)
signal roll_finished(dice_: Dice)

@export var vanguard: Vanguard
@export var pools: Array[Pool]
@export var index: int:
	set(value_):
		index = value_
		
		for pool in pools:
			pool.update_positions()

@onready var left_label = %LeftPoolLabel
@onready var right_label = %RightPoolLabel

@onready var left_pool = %LeftPool
@onready var right_pool = %RightPool

var active_dices: Array[Dice]
var spots: Array[Spot]
var soldiers: Array[Soldier]


func _ready() -> void:
	for pool in pools:
		pool.update_positions()

func distribute_pools() -> void:
	for soldier in soldiers:
		var side = Catalog.side_to_string[soldier.tent.camp.side]
		var pool = get(side+"_pool")
		pool.soldier = soldier
		soldier.pool = pool

func reset_dices() -> void:
	for pool in pools:
		pool.reset()

func roll_dices() -> void:
	#for pool in pools:
		#pool.dice.start_fake_roll()
	#
	#for pool in pools:
		#roll_finished.emit(pool.dice)
	for pool in pools:
		pool.dice.start_roll()

func start_duel() -> void:
	soldiers.front().opponent = soldiers.back()
	soldiers.back().opponent = soldiers.front()
	
	vanguard.active_duels.append(self)
	#Engine.time_scale = 1.0
	distribute_pools()
	reset_dices()
	roll_dices()

func end_duel() -> void:
	compare_roll_result()
	vanguard.duel_finished.emit(self)

func compare_roll_result() -> void:
	test_compare()

func test_compare() -> void:
	var values: Array[int]
	
	for pool in pools:
		var value = int(pool.label.text)
		values.append(value)
	
	var is_tie: bool = Judge.test_resolve_duel(soldiers, values)
	
	if is_tie:
		pass

func _on_soldier_joined(soldier_: Soldier) -> void:
	soldiers.append(soldier_)
	
	if soldiers.size() == Catalog.DUEL_UNIT_DEFAULT_COUNT:
		start_duel()

func _on_roll_finished(dice_: Dice) -> void:
	active_dices.erase(dice_)
	
	if active_dices.is_empty():
		end_duel()
