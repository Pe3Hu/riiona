class_name BattlefieldMachine
extends Machine


var simulator: BattlefieldSimulator


func _init(simulator_: BattlefieldSimulator) -> void:
	simulator = simulator_
	
	states.append_array(Catalog.battlefield_states)
	state = MachineState.new(self)
	super._init()
