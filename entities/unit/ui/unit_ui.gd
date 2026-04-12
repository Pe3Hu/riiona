class_name UnitUI
extends MarginContainer


@export var unit: Unit

@onready var initiative: Label = %InitiativeLabel
@onready var impulse: Label = %ImpulseLabel
@onready var health: Label = %HealthLabel
@onready var moral: Label = %MoralLabel



func update_labels() -> void:
	update_initiative_label(1)

func update_initiative_label(value_: int) -> void:
	initiative.text = str(value_)
