@tool
class_name Pool
extends SubViewportContainer


@export var box_size: float = 5.0:
	set(value_):
		box_size = value_
		box.mesh.size = Vector3.ONE * box_size * 0.99
@export var side: State.Side:
	set(value_):
		side = value_
		update_positions()
@export var label: Label
@export var duel: Duel
@export var camera: Camera3D
@export var box: DiceBox
@export var dice: Dice

var soldier: Soldier


func update_positions() -> void:
	box_size = box_size
	var anchor = Vector3.ZERO
	
	match side:
		State.Side.LEFT:
			anchor.x = -100
		State.Side.RIGHT:
			anchor.x = 100
	
	if duel:
		anchor.z = 128 * duel.index
	
	dice.position = anchor
	box.position = anchor
	camera.position = anchor

func reset() -> void:
	visible = true
