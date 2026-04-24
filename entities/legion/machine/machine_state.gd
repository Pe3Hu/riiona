class_name MachineState
extends Resource


var machine: Machine

var type: State.Machine


func _init(machine_: Machine) -> void:
	machine = machine_
	type = machine.states.front()

func enter() -> void:
	match type:
		State.Machine.START:
			machine.change_state(State.Machine.START, State.Machine.SPAWN)
		State.Machine.SPAWN:
			machine.simulator.init_soldiers()

func exit() -> void:
	match type:
		State.Machine.IDLE:
			var a = machine.simulator.tent.camp
			var b = machine.simulator
			pass

func update() -> void:
	pass
