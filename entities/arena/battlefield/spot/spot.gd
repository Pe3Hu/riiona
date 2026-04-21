class_name Spot
extends StaticBody2D


#signal soldier_changed(soldier_: Soldier)

var soldier: Soldier:
	set(value):
		soldier = value
		if soldier:
			soldier.current_spot = self
var pool: Pool
var fallback: Fallback

@export var phalanx: Phalanx
@export var index: int
@export var normal_color: Color = Color.MEDIUM_PURPLE
@export var highlight_color: Color = Color.ROYAL_BLUE

@onready var border_sprite: Sprite2D = %BorderSprite


func _ready() -> void:
	add_to_group("dropable")
	reset()

func reset() -> void:
	collision_layer = 1 << Catalog.DRAG_AND_DROP_LAYER
	collision_mask = 0
	update_visual(normal_color)

#region soldier
func attach_soldier(new_soldier: Soldier) -> void:
	if soldier == new_soldier: return
	
	if soldier:
		soldier.detach_from_spot()
	
	soldier = new_soldier
	
	if soldier:
		soldier.current_spot = self
		soldier.tent = phalanx.camp.tents[index - 1]
		soldier.tent.soldiers.append(soldier)
		
		if pool != null:
			pool.duel.soldier_joined.emit(soldier)
	
	update_visual_by_occupancy()
	#soldier_changed.emit(self, soldier)

func detach_soldier() -> void:
	if soldier:
		#soldier_changed.emit(self, null)
		fallback.tent.soldiers.erase(soldier)
		soldier.current_spot = null
		soldier = null
		update_visual_by_occupancy()
#endregion

#region visual
func update_visual_by_occupancy() -> void:
	if soldier:
		if border_sprite:
			border_sprite.modulate = Color.RED
	else:
		update_visual(normal_color)

func set_soldier_internal(soldier_: Soldier) -> void:
	soldier = soldier_
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


#func _on_soldier_changed(soldier: Soldier) -> void:
	#pass # Replace with function body.
