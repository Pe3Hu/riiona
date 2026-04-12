class_name Unit
extends CharacterBody2D


@export var sprite_size: Vector2i = Vector2i(64, 64)
@export var speed: float = 200.0

var type: State.Unit:
	set(value):
		type = value
		update_texture()

var current_spot: Spot = null
var target_spot: Spot = null

var is_dragging: bool = false
var can_drag: bool = false

var drag_offset: Vector2 = Vector2.ZERO
var initial_pos: Vector2 = Vector2.ZERO

var original_collision_layer: int
var original_collision_mask: int
var original_z_index: int


@onready var animations: AnimationPlayer = %AnimationPlayer
@onready var ui: UnitUI = %UnitUI
@onready var body_sprite: Sprite2D = %BodySprite
@onready var shadow_sprite: Sprite2D = %ShadowSprite
@onready var drag_area: Area2D = %DraggbleArea2D

func _ready() -> void:
	collision_layer = 2
	collision_mask = 2
	original_collision_layer = collision_layer
	original_collision_mask = collision_mask
	original_z_index = z_index
	
	if drag_area:
		drag_area.collision_layer = 8
		drag_area.collision_mask = 8
		drag_area.mouse_entered.connect(_on_mouse_entered)
		drag_area.mouse_exited.connect(_on_mouse_exited)
		drag_area.body_entered.connect(_on_drop_area_entered)
		drag_area.body_exited.connect(_on_drop_area_exited)
	
	Crane.drag_started.connect(_on_global_drag_started)
	Crane.drag_ended.connect(_on_global_drag_ended)

func _exit_tree() -> void:
	if current_spot:
		current_spot.detach_unit()

func _physics_process(_delta: float) -> void:
	if is_dragging:
		velocity = Vector2.ZERO
		move_and_slide()
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
	
	move_and_slide()
	update_animation()


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
		current_spot.detach_unit()
		current_spot = null

func end_drag(drop_spot_: Spot = null, prev_spot_: Spot = null) -> void:
	if !is_dragging:
		return
	
	is_dragging = false
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)
	
	collision_layer = original_collision_layer
	collision_mask = original_collision_mask
	z_index = original_z_index
	
	if drop_spot_:
		if drop_spot_.unit:
			swap_with(drop_spot_.unit, prev_spot_)
		else:
			move_to_spot(drop_spot_)
	else:
		if prev_spot_:
			move_to_spot(prev_spot_)

func update_drag_position(mouse_global_pos_: Vector2) -> void:
	if !is_dragging:
		return
	global_position = mouse_global_pos_ - drag_offset
#endregion

#region spot
func move_to_spot(new_spot_: Spot) -> void:
	if new_spot_ == current_spot:
		return
	
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
	if current_spot == spot_:
		return
	
	if current_spot:
		current_spot.detach_unit()
	
	current_spot = spot_
	if spot_:
		spot_.attach_unit(self)
		global_position = spot_.global_position

func return_to_previous_spot() -> void:
	var prev_spot_ = Crane.previous_spot
	if prev_spot_:
		move_to_spot(prev_spot_)

func swap_with(other_unit_: Unit, original_spot_: Spot = null) -> void:
	var my_spot = original_spot_ if original_spot_ else current_spot
	var other_spot = other_unit_.current_spot
	
	var my_layer = collision_layer
	var other_layer = other_unit_.collision_layer
	
	collision_layer = 0
	other_unit_.collision_layer = 0
	
	my_spot.detach_unit()
	other_spot.detach_unit()
	
	velocity = Vector2.ZERO
	other_unit_.velocity = Vector2.ZERO
	target_spot = null
	other_unit_.target_spot = null
	
	var tween_self = create_tween().set_ease(Tween.EASE_OUT)
	tween_self.tween_property(self, "global_position", other_spot.global_position, 0.2)
	
	var tween_other = other_unit_.create_tween().set_ease(Tween.EASE_OUT)
	tween_other.tween_property(other_unit_, "global_position", my_spot.global_position, 0.2)
	
	await tween_self.finished
	await tween_other.finished
	
	other_spot.attach_unit(self)
	my_spot.attach_unit(other_unit_)
	
	collision_layer = my_layer
	other_unit_.collision_layer = other_layer

func arrive_at_target() -> void:
	if !target_spot:
		return
	
	global_position = target_spot.global_position
	var spot_to_attach = target_spot
	target_spot = null
	attach_to_spot(spot_to_attach)

func detach_from_spot() -> void:
	current_spot = null
#endregion

#region visual
func update_texture() -> void:
	if !body_sprite:
		return
	var type_str = Catalog.unit_to_string[type]
	var path = "res://entities/unit/images/%s_unit.png" % type_str
	body_sprite.texture = load(path)

func update_animation() -> void:
	if velocity.length_squared() < 0.1:
		if animations.is_playing():
			animations.stop()
		return
	
	var direction := ""
	var v = velocity.normalized()
	
	if abs(v.x) > abs(v.y):
		direction = "Right" if v.x > 0 else "Left"
	else:
		direction = "Down" if v.y > 0 else "Up"
	
	var anim_name = "walk" + direction
	if animations.has_animation(anim_name) and animations.current_animation != anim_name:
		animations.play(anim_name)
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

func _on_global_drag_started(unit_: Unit) -> void:
	if unit_ == self: return
	can_drag = false

func _on_global_drag_ended(_unit: Unit) -> void:
	pass
#endregion
