class_name Soldier
extends Unit


@export var tent: Tent

var type: State.Soldier:
	set(value):
		type = value
		update_texture()
var duel_status: State.Duel = State.Duel.TIE

var current_spot: Spot = null
var target_spot: Spot = null
var pool: Pool = null
var opponent: Soldier = null

var is_dragging: bool = false
var can_drag: bool = false
var is_alive: bool = true
var is_idle: bool = true
var is_dueling: bool = false

var drag_offset: Vector2 = Vector2.ZERO
var initial_pos: Vector2 = Vector2.ZERO

var original_collision_layer: int
var original_collision_mask: int
var original_z_index: int

@onready var ui: UnitUI = %UnitUI
@onready var drag_area: Area2D = %DraggbleArea2D


func _ready() -> void:
	collision_layer = 1 << Catalog.UNIT_LAYER
	collision_mask = 1 << Catalog.UNIT_LAYER
	original_collision_layer = collision_layer
	original_collision_mask = collision_mask
	original_z_index = z_index
	
	if drag_area:
		drag_area.collision_layer = 1 << Catalog.DRAG_AND_DROP_LAYER
		drag_area.collision_mask = 1 << Catalog.DRAG_AND_DROP_LAYER
		drag_area.mouse_entered.connect(_on_mouse_entered)
		drag_area.mouse_exited.connect(_on_mouse_exited)
		drag_area.body_entered.connect(_on_drop_area_entered)
		drag_area.body_exited.connect(_on_drop_area_exited)
	
	Crane.drag_started.connect(_on_global_drag_started)
	Crane.drag_ended.connect(_on_global_drag_ended)

func _exit_tree() -> void:
	if current_spot:
		current_spot.detach_soldier()

func _physics_process(_delta: float) -> void:
	if is_dragging:
		velocity = Vector2.ZERO
		move_and_slide()
		update_animation()
		return
	
	if is_retreating:
		velocity = (global_position - last_position).normalized()
		last_position = global_position
		update_animation()
		return
	
	if !is_idle:
		update_animation()
		return
	
	if is_dueling:
		update_animation()
		return
	
	if target_spot:
		var direction = global_position.direction_to(target_spot.global_position)
		var distance = global_position.distance_to(target_spot.global_position)
		if distance > 5.0:
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
			arrive_at_target()
	else:
		velocity = Vector2.ZERO
	
	super._physics_process(_delta)

#region drag and drop
func start_drag(mouse_global_pos_: Vector2) -> void:
	if !can_drag:
		return
	
	is_dragging = true
	initial_pos = global_position
	drag_offset = mouse_global_pos_ - global_position
	
	original_collision_layer = collision_layer
	original_collision_mask = collision_mask
	collision_layer = 0
	collision_mask = 0
	z_index = 10
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)
	
	if current_spot:
		current_spot.detach_soldier()
		current_spot = null

func end_drag(drop_spot_: Spot = null, prev_spot_: Spot = null) -> void:
	if !is_dragging: return
	
	is_dragging = false
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)
	
	rest_collision()
	
	if drop_spot_:
		#cannot be put in the opponent's spot
		if drop_spot_.phalanx.camp != tent.camp:
			return_to_previous_spot()
			return
		
		#cannot be put in the duel's spot
		if drop_spot_.pool != null:
			return_to_previous_spot()
			return
		
		if drop_spot_.soldier:
			swap_with(drop_spot_.soldier, prev_spot_)
		else:
			move_to_spot(drop_spot_)
	else:
		if prev_spot_:
			move_to_spot(prev_spot_)

func rest_collision() -> void:
	collision_layer = original_collision_layer
	collision_mask = original_collision_mask
	z_index = original_z_index

func update_drag_position(mouse_global_pos_: Vector2) -> void:
	if !is_dragging:
		return
	global_position = mouse_global_pos_ - drag_offset
#endregion

#region spot
func move_to_spot(new_spot_: Spot) -> void:
	if new_spot_ == current_spot: return
	
	target_spot = null
	velocity = Vector2.ZERO
	
	var old_layer = collision_layer
	var old_mask = collision_mask
	collision_layer = 0
	collision_mask = 0
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", new_spot_.global_position, 0.2)\
		.set_ease(Tween.EASE_OUT)
	await tween.finished
	
	collision_layer = old_layer
	collision_mask = old_mask
	
	attach_to_spot(new_spot_)

func attach_to_spot(spot_: Spot) -> void:
	if current_spot == spot_: return
	
	if current_spot:
		current_spot.detach_soldier()
	
	current_spot = spot_
	
	if spot_:
		spot_.attach_soldier(self)
		global_position = spot_.global_position

func return_to_previous_spot() -> void:
	if Crane.previous_spot:
		move_to_spot(Crane.previous_spot)

func swap_with(other_soldier_: Soldier, original_spot_: Spot = null) -> void:
	var my_spot = original_spot_ if original_spot_ else current_spot
	var other_spot = other_soldier_.current_spot
	
	var my_layer = collision_layer
	var other_layer = other_soldier_.collision_layer
	
	collision_layer = 0
	other_soldier_.collision_layer = 0
	
	my_spot.detach_soldier()
	other_spot.detach_soldier()
	
	velocity = Vector2.ZERO
	other_soldier_.velocity = Vector2.ZERO
	target_spot = null
	other_soldier_.target_spot = null
	
	var tween_self = create_tween().set_ease(Tween.EASE_OUT)
	tween_self.tween_property(self, "global_position", other_spot.global_position, 0.2)
	
	var tween_other = other_soldier_.create_tween().set_ease(Tween.EASE_OUT)
	tween_other.tween_property(other_soldier_, "global_position", my_spot.global_position, 0.2)
	
	await tween_self.finished
	await tween_other.finished
	
	other_spot.attach_soldier(self)
	my_spot.attach_soldier(other_soldier_)
	
	collision_layer = my_layer
	other_soldier_.collision_layer = other_layer

func arrive_at_target() -> void:
	if !target_spot: return
	
	global_position = target_spot.global_position
	var spot_to_attach = target_spot
	target_spot = null
	attach_to_spot(spot_to_attach)
	
	#if tent.camp.is_march:
		#if spot_to_attach.pool != null:
			#tent.camp.is_march = false
		#else:
			#update_target_spot()
	
	if tent.camp.is_march:
		update_target_spot()

func detach_from_spot() -> void:
	current_spot = null

func update_target_spot() -> void:
	if !is_alive: return
	var spots = tent.fallback.spots
	var spot_index = (spots.find(current_spot) + 1) % spots.size()
	target_spot = spots[spot_index]
	
	if tent.camp.is_march:
		if target_spot.pool != null:
			tent.camp.empty_duels.erase(target_spot.pool.duel)
		
		if tent.camp.empty_duels.is_empty():
			tent.camp.is_march = false
#endregion

#region visual
func update_texture() -> void:
	if !body_sprite: return
	var type_str = Catalog.soldier_to_string[type]
	var path = "res://entities/unit/soldier/images/%s_soldier.png" % type_str
	body_sprite.texture = load(path)

func update_animation() -> void:
	if !is_idle:
		if duel_status != State.Duel.TIE:
			var animation_name = Catalog.duel_to_string[duel_status]
			animations.play(animation_name)
			return
	
	if is_dueling:
		var side_str = Catalog.side_to_string[tent.camp.side].capitalize()
		var animation_name = "punch%s" % side_str
		animations.play(animation_name)
		return
	
	super.update_animation()
#endregion

#region signal
func _on_mouse_entered() -> void:
	if !Crane.is_dragging:
		can_drag = true
		scale = Vector2(1.05, 1.05)

func _on_mouse_exited() -> void:
	if !Crane.is_dragging:
		can_drag = false
		scale = Vector2.ONE

func _on_drop_area_entered(body_: Node2D) -> void:
	if body_.is_in_group("dropable"):
		var spot = body_ as Spot
		if spot:
			Crane.set_current_hovered_spot(spot)

func _on_drop_area_exited(body_: Node2D) -> void:
	if body_.is_in_group("dropable"):
		Crane.clear_hovered_spot()

func _on_global_drag_started(soldier_: Soldier) -> void:
	if soldier_ == self: return
	can_drag = false

func _on_global_drag_ended(_soldier: Soldier) -> void:
	pass
#endregion

#region duel
func take_damage(damage_: int) -> void:
	var health = max(int(ui.health.text) - damage_, 0)
	ui.update_health_label(health)
	
	if health == 0:
		death()

func duel_lost() -> void:
	duel_status = State.Duel.DEFEAT
	is_idle = false
	opponent.duel_won()
	#death()
	
func duel_won() -> void:
	duel_status = State.Duel.VICTORY
	is_idle = false

func death() -> void:
	is_alive = false
	tent.soldiers.erase(self)
	enable_snake_area()
	collision_layer |= 1 << Catalog.JANITOR_LAYER
	collision_mask |= 1 << Catalog.JANITOR_LAYER
	#%DraggbleArea2D.collision_layer |= 1 << Catalog.JANITOR_LAYER
	##%DraggbleArea2D.collision_mask = 0
	z_index = Catalog.JANITOR_LAYER

func victory() -> void:
	pass
#endregion

func _on_animation_player_animation_finished(animation_name_: String) -> void:
	match animation_name_:
		"victory":
			is_idle = true
		"defeat":
			is_idle = true
		"punchLeft":
			is_dueling = false
		"punchRight":
			is_dueling = false

func _on_snake_area_body_entered(body_: Node2D) -> void:
	if body_ as Soldier:
		tent.camp.graveyard.janitor.collect_soldier(body_)

func enable_snake_area() -> void:
	%SnakeArea.set_deferred("monitoring", false)
	%SnakeArea.set_deferred("monitorable", false)

func disable_snake_area() -> void:
	%SnakeArea.set_deferred("monitoring", true)
	%SnakeArea.set_deferred("monitorable", true)

#func enable_snake_area() -> void:
	#%SnakeArea.monitorable = false
	#%SnakeArea.monitoring = false
#
#func disable_snake_area() -> void:
	#%SnakeArea.monitorable = true
	#%SnakeArea.monitoring = true
