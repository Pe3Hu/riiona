@tool
class_name Graveyard
extends Node2D


@export var time: float = 3.0
@export var camp: Camp

@onready var body_sprite: Sprite2D = %BodySprite  

@export var janitor: Janitor
@export var path: Path2D
@export var path_follow: PathFollow2D
@export var trail_sprite: Sprite2D


func activate() -> void:
	Engine.time_scale = 1.0
	janitor.is_retreating = true
	janitor.last_position = janitor.global_position
	
	var tween = create_tween()
	tween.tween_property(path_follow, "progress_ratio", 1, time)
	tween.finished.connect(reset_path)

func reset_path() -> void:
	janitor.is_retreating = false
	janitor.velocity = Vector2.ZERO
	#janitor.rest_collision()
	path_follow.progress_ratio = 0
	camp.battlefield.janitor_finished.emit(janitor)


func _on_grave_area_body_entered(body_: Node2D) -> void:
	body_.visible = false
