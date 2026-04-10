extends Node



enum DuelAction{
	MISS = 0,
	FAST = 1,
	NORMAL = 2,
	HEAVY = 3
}

#region unit
enum Bowl {
	HEALTH
}

enum Unit{
	PAWN,
	ELITE
}
#endregion

enum Fuel {
	NONE = 0,
	GAS = 2,
	LIQUID = 3,
	SOLID = 5
}

#region guise
enum Hair {
	NONE = 0,
	DARK = 2,
	RED = 3,
	BLONDE = 5
}

enum Eye {
	NONE = 0,
	GREEN = 2,
	BLUE = 3,
	BROWN = 5,
}
#endregion


enum Priority{
	FUNDAMENTAL = 0,
	COLLATERAL = 1
}

enum PokerCombo{
	NONE = 0,
	DOUBLE = 2,
	TRIPLET = 3,
	DOUBLE_DOUBLE = 10,
	DOUBLE_TRIPLET = 11,
	STRAIGHT = 20
}
