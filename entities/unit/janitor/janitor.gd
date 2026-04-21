class_name Janitor
extends Unit


@export var graveyard: Graveyard

@export var gap: int = 64

var soldiers: Array[Soldier]


func _physics_process(delta_: float) -> void:
	if !is_retreating: 
		if animations.is_playing():
			animations.stop()
		return
	
	velocity = (global_position - last_position).normalized()
	last_position = global_position
	update_animation()
	
	update_soldiers_positions(delta_)
	#super._physics_process(delta_)

func update_soldiers_positions(_delta: float):
	if soldiers.is_empty(): return
	update_follower_position(soldiers.front(), self)
	
	for _i in range(1, soldiers.size()):
		var follower = soldiers[_i]
		var target = soldiers[_i - 1]
		update_follower_position(follower, target)

func update_follower_position(follower_: Unit, target_: Unit) -> void:
	if follower_.global_position.distance_to(target_.global_position) < gap: return
	var direction = (follower_.global_position - target_.global_position).normalized()
	follower_.global_position = target_.global_position + direction * gap

func collect_soldier(soldier_: Soldier) -> void:
	if soldiers.is_empty():
		disable_snake_area()
	else:
		var last_soldier = soldiers.back()
		last_soldier.disable_snake_area()
		#collision_layer |= 1 << Catalog.JANITOR_LAYER
		#last_soldier.collision_layer = 0
		
		last_soldier.collision_layer = 1 << (Catalog.JANITOR_LAYER + 1)
		last_soldier.collision_mask = 0
	
	soldiers.append(soldier_)
	#soldier_.tent.fallback.path_follow.remove_child(soldier_)
	#graveyard.trail_sprite.add_child(soldier_)
	#soldier_.body_sprite.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	#soldier_.shadow_sprite.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW

func _on_snake_area_body_exited(body_: Node2D) -> void:
	if body_ as Soldier:
		pass

func _on_snake_area_body_entered(body_: Node2D) -> void:
	if body_ as Soldier:
		collect_soldier(body_)

func enable_snake_area() -> void:
	%SnakeArea.set_deferred("monitoring", false)
	%SnakeArea.set_deferred("monitorable", false)

func disable_snake_area() -> void:
	%SnakeArea.set_deferred("monitoring", true)
	%SnakeArea.set_deferred("monitorable", true)

func reset() -> void:
	#visible = true
	collision_mask = 1 << (Catalog.JANITOR_LAYER + 1)
	collision_layer = 1 << (Catalog.JANITOR_LAYER + 1)
	
	graveyard.soldiers.append_array(soldiers)
	soldiers.clear()
