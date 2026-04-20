class_name World
extends Node



func _ready() -> void:
	Engine.time_scale = 2.5


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()
	
