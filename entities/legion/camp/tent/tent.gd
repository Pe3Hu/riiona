@tool
class_name Tent
extends Node2D



@export var unit_scene: PackedScene
@export var camp: Camp

@export var type: State.Unit:
	set(value_):
		type = value_
		update_texture()
@export var side: State.Side
@export var index: int

@onready var body_sprite: Sprite2D = $BodySprite  # Adjust node path as needed



func _ready():
	update_texture()

func update_texture():
	if !body_sprite: return
	var type_str = Catalog.unit_to_string[type]
	var path = "res://entities/legion/camp/tent/images/%s_tent.png" % type_str
	body_sprite.texture = load(path)

func swapn_unit() -> void:
	var unit = unit_scene.instantiate()
	var phalanx = camp.current_spawn_phalanx
	var spot = phalanx.spots.get_child(index-1)
	var initiative = camp.battlefield.units.get_child_count() % 10
	camp.battlefield.units.add_child(unit)
	unit.global_position = global_position
	unit.target_spot = spot
	unit.update_initiative_label(initiative)
