class_name SoldierMachine
extends Machine


var simulator: SoldierSimulator 



func _init(simulator_: SoldierSimulator) -> void:
	simulator = simulator_
	
	states.append_array(Catalog.soldier_states)
	state = MachineState.new(self)
	super._init()
