class_name Unit
extends CharacterBody2D


@export var sprite_size: Vector2i = Vector2i(64, 64)
@export var speed: float = 200.0

var is_moving: bool = false
var draggable: bool = false
var is_inside_dropable: bool = false

var drag_spot: Node2D = null
var offset: Vector2 = Vector2.ZERO
var initial_pos: Vector2 = Vector2.ZERO

var current_spot: Spot
var target_spot: Spot:
	set(value_):
		target_spot = value_
		is_moving = true

@onready var animations: AnimationPlayer = %AnimationPlayer
@onready var initiative: Label = %InitiativeLabel


func update_animation() -> void:
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		var angle = velocity.angle()
		
		if angle < 0:
			angle += PI * 2
		
		var direction = "Right"
		
		if angle >= PI/4 and angle < PI*3/4:
			direction = "Down"
		elif angle >= PI*3/4 and angle < PI*5/4:
			direction = "Left"
		elif angle >= PI*5/4 and angle < PI*7/4:
			direction = "Up"
		
		animations.play("walk" + direction)

func _physics_process(_delta: float) -> void:
	if is_moving:
		move_towards_target(_delta)
	
	move_and_slide()
	update_animation()

func _process(_delta: float) -> void:
	drag()

func drag() -> void:
	if draggable:
		Catalog.previous_spot = current_spot
		Catalog.next_spot = null
		
		#set_collision_layer_value(2, false)
		
		if Input.is_action_just_pressed("click"):
			initial_pos = global_position
			offset = get_global_mouse_position() - global_position
			Catalog.is_dragging = true
			
			# Анимация масштабирования при захвате
			var tween = get_tree().create_tween()
			tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)
		
		elif Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		
		elif Input.is_action_just_released("click"):
			drop()


func drop() -> void:
	Catalog.is_dragging = false
	#set_collision_layer_value(2, true)
	
	# Если внутри drop zone - оставляем на месте
	if is_inside_dropable and drag_spot != null:
		place_on_new_spot()
	# Иначе возвращаем на исходную позицию
	else:
		return_last_spot()

func return_last_spot() -> void:
	set_collision_layer_value(2, false)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", initial_pos, 0.2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	await tween.finished
	set_collision_layer_value(2, true)

func place_on_new_spot() -> void:
	#if drag_spot.unit != null: 
		#swap_units()
	#	return
	
	var tween = get_tree().create_tween()
	#tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", drag_spot.global_position, 0.2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	current_spot = drag_spot

func swap_units() -> void:
	#var a = Catalog.next_spot
	#var b = Catalog.previous_spot
	
	var first_unit = drag_spot.unit
	first_unit.place_on_new_spot()

func move_towards_target(_delta: float) -> void:
	var distance = global_position.distance_to(target_spot.global_position)
	
	if distance > 5.0:
		velocity = global_position.direction_to(target_spot.global_position) * speed
	else:
		velocity = Vector2.ZERO
		is_moving = false
		current_spot = target_spot

func update_initiative_label(value_: int) -> void:
	initiative.text = str(value_)

func _on_area_2d_mouse_entered() -> void:
	if !Catalog.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)
		#set_collision_layer_value(2, false)

func _on_area_2d_mouse_exited() -> void:
	if !Catalog.is_dragging:
		draggable = false
		scale = Vector2(1.0, 1.0)
		#set_collision_layer_value(2, true)

func _on_area_2d_body_entered(body_: Node2D) -> void:
	if body_.is_in_group("dropable"):
		is_inside_dropable = true
		drag_spot = body_
		drag_spot.unit = self
		#drag_spot.units.append(self)
		
		if Catalog.is_dragging:
			Catalog.next_spot = drag_spot
		
		body_.modulate = Color(Color.ROYAL_BLUE, 1.0)
		#body_.set_meta("body", body_)

func _on_area_2d_body_exited(body_: Node2D) -> void:
	if body_.is_in_group("dropable"):
		is_inside_dropable = false
		drag_spot.unit = null
		#drag_spot.units.erase(self)
		drag_spot = null
		
		if Catalog.is_dragging:
			Catalog.next_spot = null
		
		body_.modulate = Color(Color.MEDIUM_PURPLE, 0.7)
