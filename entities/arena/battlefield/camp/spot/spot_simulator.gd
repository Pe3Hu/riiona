class_name SpotSimulator
extends Resource


var camp: CampSimulator
var column: ColumnSimulator
var phalanx: PhalanxSimulator
var soldier: SoldierSimulator

var grid: Vector2i


func _init(camp_: CampSimulator, grid_: Vector2i) -> void:
	camp = camp_
	grid = grid_


#region soldier
func attach_soldier(new_soldier: SoldierSimulator) -> void:
	if soldier == new_soldier: return
	
	if soldier:
		soldier.detach_from_spot()
	
	soldier = new_soldier
	
	if soldier:
		soldier.current_spot = self
		soldier.tent = column.tent
		soldier.tent.soldiers.append(soldier)
		
		#if pool != null:
			#pool.duel.soldier_joined.emit(soldier)

func detach_soldier() -> void:
	if soldier:
		column.tent.soldiers.erase(soldier)
		soldier.current_spot = null
		soldier = null
#endregion
