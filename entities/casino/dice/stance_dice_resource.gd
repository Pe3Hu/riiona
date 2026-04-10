class_name StanceDiceResource
extends DiceResource


var unit: UnitResource


func _init(unit_: UnitResource) -> void:
	unit = unit_
	super._init()
	
	init_faces()

func init_faces() -> void:
	faces.append_array(Catalog.defaul_actions)
	
	match unit.type:
		State.Unit.PAWN:
			while faces.size() != Catalog.D6_SIZE:
				faces.append(State.DuelAction.MISS)
		State.Unit.ELITE:
			var fuel = Catalog.hair_to_fuel[unit.guise.hair]
			var action = Catalog.fuel_to_action[fuel]
			
			for _i in Catalog.FUNDAMENTAL_SIZE:
				faces.append(action)
			
			fuel = Catalog.hair_to_fuel[unit.guise.eye]
			action = Catalog.fuel_to_action[fuel]
			
			for _i in Catalog.COLLATERAL_SIZE:
				faces.append(action)

func roll() -> Variant:
	super.roll()
	var action = Catalog.action_to_string[current_face]
	var path = "res://entities/casino/dice/impulse/{action}_{mastery}.tres".format({"action": action, "mastery": unit.mastery})
	unit.impulse = load(path)
	return current_face
