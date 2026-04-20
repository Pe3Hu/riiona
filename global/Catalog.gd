extends Node


const D6_SIZE = 6

const DUEL_UNIT_DEFAULT_COUNT = 2

const LEGION_PAWN_DEFAULT_COUNT = 18
const LEGION_ELITE_DEFAULT_COUNT = 12

#region guise
const eye_options = [State.Eye.GREEN, State.Eye.BLUE, State.Eye.BROWN]
const hair_options = [State.Hair.DARK, State.Hair.RED, State.Hair.BLONDE]

const eye_to_fuel = {
	State.Eye.GREEN: State.Fuel.GAS,
	State.Eye.BLUE: State.Fuel.LIQUID,
	State.Eye.BROWN: State.Fuel.SOLID,
}

const hair_to_fuel = {
	State.Hair.DARK: State.Fuel.GAS,
	State.Hair.RED: State.Fuel.LIQUID,
	State.Hair.BLONDE: State.Fuel.SOLID,
}

const FUNDAMENTAL_SIZE = 2
const COLLATERAL_SIZE = 1
#endregion

#region action
const defaul_actions = [State.DuelAction.FAST, State.DuelAction.NORMAL, State.DuelAction.HEAVY]

const fuel_to_action = {
	State.Fuel.GAS: State.DuelAction.FAST,
	State.Fuel.LIQUID: State.DuelAction.NORMAL,
	State.Fuel.SOLID: State.DuelAction.HEAVY,
}

const action_to_string = {
	State.DuelAction.MISS: "miss",
	State.DuelAction.FAST: "fast",
	State.DuelAction.NORMAL: "normal",
	State.DuelAction.HEAVY: "heavy",
}
#endregion

#region poker
const POKER_SIZE = 5

const single_to_combo = {
	2: State.PokerCombo.DOUBLE,
	3: State.PokerCombo.TRIPLET
}

const pair_to_combo = {
	2: State.PokerCombo.DOUBLE_DOUBLE,
	3: State.PokerCombo.DOUBLE_TRIPLET
}

const combo_to_string = {
	State.PokerCombo.NONE: "none",
	State.PokerCombo.DOUBLE: "pair",
	State.PokerCombo.TRIPLET: "triple",
	State.PokerCombo.DOUBLE_DOUBLE: "two pairs",
	State.PokerCombo.DOUBLE_TRIPLET: "full house",
	State.PokerCombo.STRAIGHT: "straight"
}
#endregion


const soldier_to_string = {
	State.Soldier.PAWN: "pawn",
	State.Soldier.ELITE: "elite"
}

const side_to_string = {
	State.Side.LEFT: "left",
	State.Side.RIGHT: "right"
}

const phalanx_to_offset = {
	State.Phalanx.TIGHT: Vector2(0, -128),
	State.Phalanx.GAP: Vector2(0, -128),
}

const duel_to_string = {
	State.Duel.TIE: "tie",
	State.Duel.VICTORY: "victory",
	State.Duel.DEFEAT: "defeat",
}
