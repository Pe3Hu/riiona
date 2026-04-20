@tool
class_name DiceBox
extends MeshInstance3D


@export var dice: Dice

var shader_material: ShaderMaterial
var dissolve_tween: Tween
var rotation_tween: Tween


func _ready():
	#update_size()
	var shader = preload("res://entities/arena/vanguard/duel/pool/box/dissolve.gdshader")
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	reset()
	shader_material.set_shader_parameter("edgeColor", Color.WHITE)
	material_override = shader_material

func reset() -> void:
	shader_material.set_shader_parameter("edgesThickness", 0.01)
	shader_material.set_shader_parameter("dissolveSlider", -1)

func start_dissolve():
	shader_material.set_shader_parameter("edgesThickness", 0.1)
	
	if dissolve_tween:
		dissolve_tween.kill()

	dissolve_tween = create_tween()
	dissolve_tween.set_parallel(true)
	var duration = 1.5
	
	animate_shader_param("dissolveSlider", -0.15, 1.1, duration)

func animate_shader_param(param_name: String, from: float, to: float, duration: float):
	dissolve_tween.tween_method(
		func(value): shader_material.set_shader_parameter(param_name, value),
		from, to, duration
	)#.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)#EASE_OUT_IN EASE_IN_OUT

func update_size() -> void:
	if dice:
		mesh.size = Vector3.ONE * (dice.box_size * 0.9)

func start_roll() -> void:
	if rotation_tween:
		rotation_tween.kill()
	
	animate_steps()

func animate_steps() -> void:
	var b: Basis = dice.current_basis

	rotation_tween = create_tween()

	var n: int = dice.steps.size()

	for i in range(n):
		var step = dice.steps[i]

		var axis: Vector3 = dice.axes[step["axis_index"]]
		var angle: float = deg_to_rad(90.0 * step["turns"])

		var start_basis: Basis = b
		var end_basis: Basis = b.rotated(axis, angle)

		b = end_basis

		var t: float = float(i) / float(max(n - 1, 1))
		var speed_factor: float = pow(1.8, t)
		var duration: float = dice.step_duration * speed_factor

		if step["turns"] == 2:
			duration *= 2.0

		rotation_tween.tween_method(func(p: float) -> void:
			var ease_t := 1.0 - pow(1.0 - p, 3.0)
			var q0: Quaternion = Quaternion(start_basis)
			var q1: Quaternion = Quaternion(end_basis)
			global_transform.basis = Basis(q0.slerp(q1, ease_t))
		, 0.0, 1.0, duration)
