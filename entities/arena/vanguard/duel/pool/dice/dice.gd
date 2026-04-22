@tool
class_name Dice
extends Node3D


@export var pool: Pool
@export var roll_min_steps: int = 4
@export var roll_max_steps: int = 6
@export var step_duration: float = 0.25

@export var camera: Camera3D


var faces: Node3D = Node3D.new()
var cube: MeshInstance3D = MeshInstance3D.new()

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var current_basis: Basis
var target_basis: Basis
var steps: Array = []
var tween: Tween

var axes: Array[Vector3] = [
	Vector3.RIGHT,
	Vector3.UP,
	Vector3.BACK
]

var face_directions: Array[Vector3] = [
	Vector3(0, 1, 0),
	Vector3(0, -1, 0),
	Vector3(1, 0, 0),
	Vector3(-1, 0, 0),
	Vector3(0, 0, 1),
	Vector3(0, 0, -1)
]

var face_rotations: Array[Vector3] = [
	Vector3(-90, 0, 0),
	Vector3(90, 0, 0),
	Vector3(0, 90, 0),
	Vector3(0, -90, 0),
	Vector3(0, 0, 0),
	Vector3(0, 180, 0)
]

var face_values = [1, 2, 3, 4, 5, 6]


func _ready() -> void:
	rng.randomize()
	init_faces()
	current_basis = global_transform.basis
	target_basis = current_basis
	#dissolve()
	#start_roll()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SPACE:
			start_roll()

func start_fake_roll() -> void:
	if pool.side == State.Side.RIGHT:
		pool.label.text = str(1)
	
	pool.duel.active_dices.append(self)

func start_roll() -> void:
	pool.spot.soldier.is_dueling = true
	visible = true
	pool.duel.active_dices.append(self)
	pool.box.reset()
	
	if tween:
		tween.kill()

	steps = generate_steps()
	pool.duel.active_dices.append(self)

	if steps.size() > 0 and steps[steps.size() - 1]["axis_index"] == 1:
		var axis_index: int = rng.randi_range(0, 2)
		while axis_index == 1:
			axis_index = rng.randi_range(0, 2)

		var turns: int = 1 if rng.randf() < 0.5 else 2

		steps.append({
			"axis_index": axis_index,
			"turns": turns
		})

	target_basis = simulate(current_basis, steps)
	animate_steps()
	pool.box.start_roll()

func generate_steps() -> Array:
	var n: int = rng.randi_range(roll_min_steps, roll_max_steps)
	var result: Array = []
	var prev_axis: int = -1

	for i in range(n):
		var axis_index: int = rng.randi_range(0, 2)

		while axis_index == prev_axis:
			axis_index = rng.randi_range(0, 2)

		prev_axis = axis_index

		var turns: int = 1 if rng.randf() < 0.7 else 2

		result.append({
			"axis_index": axis_index,
			"turns": turns
		})

	return result

func simulate(b: Basis, s: Array) -> Basis:
	var r: Basis = b

	for step in s:
		var axis: Vector3 = axes[step["axis_index"]]
		var angle: float = deg_to_rad(90.0 * step["turns"])
		r = r.rotated(axis, angle)

	return r

func get_top_from_basis(b: Basis) -> int:
	var best_dot: float = -1.0
	var best_index: int = 0

	for i in range(6):
		var n: Vector3 = b * face_directions[i]
		var d: float = n.dot(Vector3.UP)
		if d > best_dot:
			best_dot = d
			best_index = i

	return face_values[best_index]

func animate_steps() -> void:
	var b: Basis = current_basis

	tween = create_tween()

	var n: int = steps.size()

	for i in range(n):
		var step = steps[i]

		var axis: Vector3 = axes[step["axis_index"]]
		var angle: float = deg_to_rad(90.0 * step["turns"])

		var start_basis: Basis = b
		var end_basis: Basis = b.rotated(axis, angle)

		b = end_basis

		var t: float = float(i) / float(max(n - 1, 1))
		var speed_factor: float = pow(1.8, t)
		var duration: float = step_duration * speed_factor

		if step["turns"] == 2:
			duration *= 2.0

		tween.tween_method(func(p: float) -> void:
			var ease_t := 1.0 - pow(1.0 - p, 3.0)
			var q0: Quaternion = Quaternion(start_basis)
			var q1: Quaternion = Quaternion(end_basis)
			global_transform.basis = Basis(q0.slerp(q1, ease_t))
		, 0.0, 1.0, duration)

	tween.finished.connect(stop_roll)

func get_top_face_value() -> int:
	var best_dot: float = -1.0
	var best_index: int = 0

	for i in range(6):
		var n: Vector3 = current_basis * face_directions[i]
		var d: float = n.dot(Vector3.DOWN)
		if d > best_dot:
			best_dot = d
			best_index = i

	return face_values[best_index]

func init_faces() -> void:
	add_child(faces)
	var h: float = pool.box_size * 0.5
	
	for _i in face_values.size():
		var value = face_values[_i]
		var path = "%s.png" % [value]
		var offset = face_directions[_i] * h
		var _rotation = face_rotations[_i]
		add_face(path, offset, _rotation)

func add_face(path_: String, position_: Vector3, rotation_: Vector3) -> void:
	var mesh: MeshInstance3D = MeshInstance3D.new()
	var quad: QuadMesh = QuadMesh.new()
	quad.size = Vector2(pool.box_size, pool.box_size)

	mesh.mesh = quad
	mesh.position = position_
	mesh.rotation_degrees = rotation_

	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.cull_mode = BaseMaterial3D.CULL_FRONT
	material.albedo_texture = load("res://entities/arena/vanguard/duel/pool/dice/images/" + path_)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh.material_override = material
	
	faces.add_child(mesh)

func stop_roll() -> void:
	current_basis = target_basis
	global_transform.basis = target_basis
	update_label()
	pool.duel.active_dices.erase(self)
	#pool.duel.update_state()

func update_label() -> void:
	var old_text = pool.label.text
	var new_value = int(old_text) + get_top_face_value()
	
	#test
	#if pool.side == State.Side.RIGHT:
		#new_value = 69
	#else:
		#new_value = 99
	
	var stretch_tween = LabelManager.stretch_label(pool.label, str(new_value))
	await stretch_tween.finished
	dissolve()

func dissolve() -> void:
	visible = false
	pool.box.start_dissolve()
	await pool.box.dissolve_tween.finished
	pool.duel.roll_finished.emit(self)

func flip_on_face() -> void:
	pass

#func _on_tree_entered() -> void:
	#SignalManager.impulse_dice_rolled.connect(start_roll)
	#SignalManager.impulse_dice_stopped.connect(stop_roll)
#
#func _on_tree_exited() -> void:
	#SignalManager.impulse_dice_rolled.disconnect(start_roll)
	#SignalManager.impulse_dice_stopped.disconnect(stop_roll)
