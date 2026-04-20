class_name Unit
extends CharacterBody2D


@export var sprite_size: Vector2i = Vector2i(64, 64)
@export var speed: float = 200.0

@onready var animations: AnimationPlayer = %AnimationPlayer
@onready var body_sprite: Sprite2D = %BodySprite
@onready var shadow_sprite: Sprite2D = %ShadowSprite

var is_retreating: bool = false

var last_position: Vector2


func update_animation() -> void:
	#if !is_alive: return
	var animation_name
	
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
	
	animation_name = "walk" + direction
	
	if animations.has_animation(animation_name) and animations.current_animation != animation_name:
		animations.play(animation_name)

func _physics_process(_delta: float) -> void:
	move_and_slide()
	update_animation()
