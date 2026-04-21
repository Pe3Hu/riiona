extends Node


signal drag_started(unit: Unit)
signal drag_ended(unit: Unit)

var is_dragging: bool = false
var dragged_unit: Unit = null
var previous_spot: Spot = null
var current_hovered_spot: Spot = null


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		try_start_drag(event.global_position)
	elif event.is_action_released("click") and is_dragging:
		end_drag()
	elif event is InputEventMouseMotion and is_dragging and dragged_unit:
		dragged_unit.update_drag_position(event.global_position)

func try_start_drag(mouse_global_pos_: Vector2) -> void:
	if is_dragging: return
	
	var space_state = get_viewport().get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_global_pos_
	query.collide_with_areas = true
	query.collision_mask = 8
	
	var results = space_state.intersect_point(query)
	for result in results:
		var area = result.collider
		if area is Area2D and area.get_parent() is Unit:
			var unit = area.get_parent() as Unit
			if unit.can_drag:
				start_drag(unit, mouse_global_pos_)
				break

func start_drag(unit: Unit, mouse_global_pos_: Vector2) -> void:
	dragged_unit = unit
	previous_spot = unit.current_spot
	is_dragging = true
	
	unit.start_drag(mouse_global_pos_)
	drag_started.emit(unit)

func end_drag() -> void:
	if !dragged_unit: return
	
	var drop_spot = current_hovered_spot
	var prev_spot = previous_spot
	
	dragged_unit.end_drag(drop_spot, prev_spot)
	drag_ended.emit(dragged_unit)
	
	dragged_unit = null
	previous_spot = null
	current_hovered_spot = null
	is_dragging = false

func set_current_hovered_spot(spot_: Spot) -> void:
	if current_hovered_spot:
		current_hovered_spot.set_highlight(false)
	current_hovered_spot = spot_
	if spot_:
		spot_.set_highlight(true)

func clear_hovered_spot() -> void:
	if current_hovered_spot:
		current_hovered_spot.set_highlight(false)
	current_hovered_spot = null
