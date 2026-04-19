class_name  Duel
extends Node2D


@export var pools: Array[Pool]

@onready var left_label = %LeftPoolLabel
@onready var right_label = %RightPoolLabel

var active_dices: Array[Dice]


func _ready() -> void:
	for pool in pools:
		pool.update_positions()


func update_state() -> void:
	if true: return
	if active_dices.is_empty():
		roll_dices()

func roll_dices() -> void:
	for pool in pools:
		pool.dice.start_roll()
