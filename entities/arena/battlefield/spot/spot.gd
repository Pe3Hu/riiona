class_name Spot
extends StaticBody2D


func _ready() -> void:
	add_to_group("dropable")
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)


func _process(_delta: float) -> void:
	if Catalog.is_dragging:
		visible = true
	else:
		visible = false
