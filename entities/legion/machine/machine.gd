class_name Machine
extends Resource


#signal state_transition

var state: MachineState

var states: Array[State.Machine]


func _init() -> void:
	state.enter()

func change_state(source_state_: State.Machine, new_state_: State.Machine) -> void:
	if source_state_ != state.type:
		print("invalid change_state: source_state_ != state.type")
		return
	
	if !states.has(new_state_):
		print("invalid change_state: !states.has(new_state_)")
		return
	
	if state:
		state.exit()
	
	state.type = new_state_
	state.enter()
