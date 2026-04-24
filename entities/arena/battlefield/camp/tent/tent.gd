@tool
class_name Tent
extends Node2D


@export var soldier_scene: PackedScene
@export var camp: Camp
@export var column: Column

@export var type: State.Soldier:
	set(value_):
		type = value_
		update_texture()
@export var side: State.Side
@export var index: int

@onready var body_sprite: Sprite2D = %BodySprite  

var soldiers: Array[Soldier]


func _ready():
	update_texture()

func update_texture():
	if !body_sprite: return
	var type_str = Catalog.soldier_to_string[type]
	var side_str = Catalog.side_to_string[side]
	var path = "res://entities/legion/camp/tent/images/%s_tent_%s.png" % [type_str, side_str]
	body_sprite.texture = load(path)

func swapn_soldier() -> void:
	var soldier = soldier_scene.instantiate()
	var phalanx = camp.current_spawn_phalanx
	var spot = phalanx.spots[index - 1]
	var initiative = camp.battlefield.soldiers.get_child_count() % 10
	camp.battlefield.soldiers.add_child(soldier)
	soldier.global_position = global_position
	soldier.type = type
	soldier.target_spot = spot
	soldier.tent = self
	soldier.ui.update_initiative_label(initiative)
	camp.soldiers.append(soldier)
	soldiers.append(soldier)

func update_target_spot() -> void:
	pass
