class_name Spot
extends StaticBody2D

signal unit_changed(spot: Spot, unit: Unit)

var unit: Unit:
	set(value):
		unit = value
		if unit:
			unit.current_spot = self

@export var normal_color: Color = Color.MEDIUM_PURPLE
@export var highlight_color: Color = Color.ROYAL_BLUE

@onready var border_sprite: Sprite2D = %BorderSprite


func _ready() -> void:
	collision_layer = 8
	collision_mask = 0
	add_to_group("dropable")
	update_visual(normal_color)

#region unit
func attach_unit(new_unit: Unit) -> void:
	if unit == new_unit:
		return
	
	if unit:
		unit.detach_from_spot()
	
	unit = new_unit
	if unit:
		unit.current_spot = self
	
	update_visual_by_occupancy()
	unit_changed.emit(self, unit)

func detach_unit() -> void:
	if unit:
		unit_changed.emit(self, null)
		unit.current_spot = null
		unit = null
		update_visual_by_occupancy()
#endregion

#region visual
func update_visual_by_occupancy() -> void:
	if unit:
		if border_sprite:
			border_sprite.modulate = Color.RED
	else:
		update_visual(normal_color)

func set_unit_internal(unit_: Unit) -> void:
	unit = unit_
	update_visual_by_occupancy()

func set_highlight(is_active_: bool) -> void:
	if is_active_:
		update_visual(highlight_color)
	else:
		update_visual(normal_color)

func update_visual(color_: Color) -> void:
	if border_sprite:
		border_sprite.modulate = color_
#endregion
