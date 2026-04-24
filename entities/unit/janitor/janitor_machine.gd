class_name JanitorMachine
extends Machine


var simulator: JanitorSimulator 


func _init(simulator_: JanitorSimulator) -> void:
	simulator = simulator_
	
	states.append_array(Catalog.janitor_states)
	state = MachineState.new(self)
