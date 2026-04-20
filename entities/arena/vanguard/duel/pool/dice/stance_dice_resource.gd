class_name StanceDiceResource
extends DiceResource


var soldier: SoldierResource


func _init(soldier_: SoldierResource) -> void:
	soldier = soldier_
	super._init()
	
	init_faces()

func init_faces() -> void:
	faces.append_array(Catalog.defaul_actions)
	
	match soldier.type:
		State.Soldier.PAWN:
			while faces.size() != Catalog.D6_SIZE:
				faces.append(State.DuelAction.MISS)
		State.Soldier.ELITE:
			var fuel = Catalog.hair_to_fuel[soldier.guise.hair]
			var action = Catalog.fuel_to_action[fuel]
			
			for _i in Catalog.FUNDAMENTAL_SIZE:
				faces.append(action)
			
			fuel = Catalog.hair_to_fuel[soldier.guise.eye]
			action = Catalog.fuel_to_action[fuel]
			
			for _i in Catalog.COLLATERAL_SIZE:
				faces.append(action)

func roll() -> Variant:
	super.roll()
	var action = Catalog.action_to_string[current_face]
	var path = "res://entities/arena/vanguard/duel/pool/dice/impulse/{action}_{mastery}.tres".format({"action": action, "mastery": soldier.mastery})
	soldier.impulse = load(path)
	return current_face
