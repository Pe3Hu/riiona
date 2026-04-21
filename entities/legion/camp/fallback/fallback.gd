class_name Fallback
extends Node2D


@export var time: float = 2.0
@export var index: int

@export var tent: Tent
@export var soldier: Soldier:
	set(value_):
		#if value_ == null: return
		soldier = value_
		soldier.tent.camp.battlefield.soldiers.remove_child(soldier)
		soldier.position = Vector2()
		path_follow.add_child(soldier)

@export var path: Path2D
@export var path_follow: PathFollow2D

@export var spots: Array[Spot]


func activate() -> void:
	if !tent.camp.is_march:
		tent.camp.is_march = true
	
	soldier = spots.back().soldier
	
	if soldier.is_alive:
		tent.camp.active_fallbacks.append(self)
		
		soldier.is_retreating = true
		soldier.last_position = soldier.global_position
		soldier.collision_layer = 0
		soldier.collision_mask = 0
		soldier.z_index = 1
		
		var tween = create_tween()
		tween.tween_property(path_follow, "progress_ratio", 1, time)
		tween.finished.connect(reset_path)

func reset_path() -> void:
	path_follow.remove_child(soldier)
	soldier.tent.camp.battlefield.soldiers.add_child(soldier)
	soldier.attach_to_spot(spots.front())
	#soldier.global_position = spots.front().global_position
	soldier.is_retreating = false
	soldier.rest_collision()
	path_follow.progress_ratio = 0
	tent.camp.fallback_finished.emit(self)

func switch_side() -> void:
	var points: Array[Vector2]
	
	for _i in path.curve.point_count:
		var point = path.curve.get_point_position(_i)
		point.x *= -1
		points.append(point)
		#path.curve.set_point_position(_i, point)
	
	var curve = Curve2D.new()
	for point in points:
		curve.add_point(point)
	
	path.curve = curve
