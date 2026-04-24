class_name SoldierSimulator
extends Resource


var tent: TentSimulator
var current_spot: SpotSimulator
var target_spot: SpotSimulator

var machine: SoldierMachine = SoldierMachine.new(self)
var health: BowlSimulator = BowlSimulator.new(self, State.Bowl.HEALTH)
var guise: GuiseSimulator = GuiseSimulator.new(self)

var stance: StanceDiceSimulator
var impulse: ImpulseDiceSimulator

var type: State.Soldier
var initiative: int
var mastery: int = 1

var is_alive: bool = true


func _init(tent_: TentSimulator, initiative_: int) -> void:
	tent = tent_
	type = tent.type
	initiative = initiative_
	
	stance = StanceDiceSimulator.new(self)

func take_damage(damage_: int) -> void:
	health.change_value(-damage_)


#region spot
func skip_movement() -> void:
	if current_spot != null: return
	arrive_at_target()


func move_to_spot(new_spot_: SpotSimulator) -> void:
	if new_spot_ == current_spot: return
	attach_to_spot(new_spot_)

func attach_to_spot(spot_: SpotSimulator) -> void:
	if current_spot == spot_: return
	
	if current_spot:
		current_spot.detach_soldier()
	
	current_spot = spot_
	
	if spot_:
		spot_.attach_soldier(self)

func swap_with(other_soldier_: SoldierSimulator, original_spot_: SpotSimulator = null) -> void:
	var my_spot = original_spot_ if original_spot_ else current_spot
	var other_spot = other_soldier_.current_spot
	
	my_spot.detach_soldier()
	other_spot.detach_soldier()
	
	target_spot = null
	other_soldier_.target_spot = null
	
	other_spot.attach_soldier(self)
	my_spot.attach_soldier(other_soldier_)

func arrive_at_target() -> void:
	if !target_spot: return
	
	var spot_to_attach = target_spot
	target_spot = null
	attach_to_spot(spot_to_attach)
	
	if tent.camp.is_march:
		update_target_spot()

func detach_from_spot() -> void:
	current_spot = null

func update_target_spot() -> void:
	if !is_alive: return
	var spots = tent.column.spots
	var spot_index = (spots.find(current_spot) + 1) % spots.size()
	target_spot = spots[spot_index]
	
	if tent.camp.is_march:
		if target_spot.pool != null:
			var _a = tent.camp.empty_duels
			tent.camp.empty_duels.erase(target_spot.pool.duel)
		
		if tent.camp.empty_duels.is_empty():
			tent.camp.last_march_solider = self
			tent.camp.is_march = false
#endregion
