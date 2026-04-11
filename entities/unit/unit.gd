class_name Unit
extends CharacterBody2D


@export var sprite_size: Vector2i = Vector2i(16, 16)
@export var speed: float = 200.0

var is_moving: bool = false
var draggable: bool = false
var is_inside_dropable: bool = false

var target_position: Vector2
var body_ref: Node2D = null
var offset: Vector2 = Vector2.ZERO
var initial_pos: Vector2 = Vector2.ZERO

@onready var animations: AnimationPlayer = $AnimationPlayer




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
			Catalog.is_dragging = false
			var tween = get_tree().create_tween()
			
			# Если внутри drop zone - оставляем на месте
			if is_inside_dropable:
				tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
				tween.parallel().tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				# Иначе возвращаем на исходную позицию
				#tween.set_trans(Tween.TRANS_CUBIC)
				tween.parallel().tween_property(self, "global_position", initial_pos, 0.2).set_ease(Tween.EASE_OUT)
				tween.parallel().tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

func move_towards_target(_delta: float) -> void:
	var current_position = global_position
	var distance = current_position.distance_to(target_position)
	
	if distance > 5.0:
		velocity = current_position.direction_to(target_position) * speed
	else:
		velocity = Vector2.ZERO
		is_moving = false

func move_to(target: Vector2) -> void:
	target_position = target
	is_moving = true


func _on_area_2d_mouse_entered() -> void:
	if !Catalog.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited() -> void:
	if !Catalog.is_dragging:
		draggable = false
		scale = Vector2(1.0, 1.0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		body_ref = body
		body.modulate = Color(Color.REBECCA_PURPLE, 1.0)
		body.set_meta("body", body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = false
		body.modulate = Color(Color.MEDIUM_PURPLE, 0.7)
		body_ref = null
