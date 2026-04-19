extends Node


func display_number(parent_, value: int, position: Vector2, is_critical: bool = false):
	var time = 0.3
	var label = Label.new()
	label.global_position = position
	label.text = str(value)
	label.z_index = 5
	label.label_settings = LabelSettings.new()

	var color = "#FFF"
	if is_critical:
		color = "#B22"
	if value == 0:
		color = "#FFF8"

	label.label_settings.font_color = color
	label.label_settings.font_size = 24
	label.label_settings.outline_color = "#000"
	label.label_settings.outline_size = 2
	label.label_settings.font = load("res://assets/fonts/dpcomic.ttf")
	parent_.call_deferred("add_child", label)

	await label.resized
	label.pivot_offset = Vector2(label.size / 2)

	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		label, "position:y", label.position.y - 24, time
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		label, "position:y", label.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(time)
	tween.tween_property(
		label, "scale", Vector2.ZERO, time
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	label.queue_free()

func stretch_label(label: Label, new_text_: String) -> Tween:
	label.pivot_offset = Vector2(label.size / 2)
	var time = 0.6
	var first_time = time * 0.45
	var last_time = time * 0.55

	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(
		label, "position:y", label.position.y - label.size.y * 0.25, first_time
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		label, "scale:x", label.scale.x * 1.2, first_time
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		label, "scale:y", label.scale.y * 1.5, first_time
	).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		label, "position:y", label.position.y, last_time
	).set_ease(Tween.EASE_IN).set_delay(first_time)
	tween.tween_property(
		label, "scale:x", label.scale.x, last_time
	).set_ease(Tween.EASE_IN).set_delay(first_time)
	tween.tween_property(
		label, "scale:y", label.scale.y, last_time
	).set_ease(Tween.EASE_IN).set_delay(first_time)
	tween.tween_property(
		label, "text", new_text_, 0
	).set_ease(Tween.EASE_IN).set_delay(first_time)
	
	return tween
