extends Node

## Provided Signals
signal currentIncome_changed()
signal currentExpenses_changed()

signal existingShips_changed()

## Exported vars
#export var STARTING_SCOUTS := 3

## Internal Vars
enum ShipType {SC, DD, CA, BC, BB, DN, CO, BS, MR, SY, DC}
enum Tech {
	ShipSize, 
	Attack, 
	Defense, 
	Tactics, 
	Move, 
	ShipYard, 
	Terraform, 
	Exploration
}

## Current Econ Phase
var colonyIncome := 20 setget setColonyIncome
var mineralIncome := 0 setget setMineralIncome

var turnOrderBid := 0 setget setTurnOrderBid
var newTech := {}
var newShips := {}
var currentIncome := 0 setget setNothing
var currentExpenses := 0 setget setNothing

# Don't allow people to set these
func setNothing(value):
	print("Read only!")

## Last Econ Phase
var researchedTech := {}
var existingShips := {}
var lastTurnCarryOver := 0

## Methods
func _ready():
	resetExistingShips()
	resetTech()

func resetEconPhase():
	colonyIncome = 20
	mineralIncome = 0
	
	turnOrderBid = 0
	newTech = {}
	newShips = {}

func goToPlayPhase():
	# Add new ships
	for shpTyp in newShips:
		existingShips[shpTyp] = existingShips.get(shpTyp, 0) + newShips[shpTyp]
	# Add upgraded tech
	for techTyp in newTech:
		researchedTech[techTyp] = researchedTech.get(techTyp, 0) + newTech[techTyp]
	lastTurnCarryOver = getRemainingCp()

func goToEconPhase():
	resetEconPhase()

## Empire-wide
func resetExistingShips():
	existingShips = {ShipType.SC: 3, ShipType.CO: 3, ShipType.SY: 4, ShipType.MR: 1}

func resetTech():
	researchedTech = {Tech.ShipSize: 1, Tech.Move: 1, Tech.ShipYard: 1}

func getExistingMaintance() -> int:
	var maint := 0
	for shpTyp in existingShips:
		print("Constructed ship type found: ", shpTyp, " from: ", existingShips[shpTyp])
		maint += getShipTypeMaintance(shpTyp) * existingShips[shpTyp]
	print("Existing Maintance:", maint)
	return maint

## Income
func setColonyIncome(new_cp:int):
	colonyIncome = new_cp
	_updateIncome()
	emit_signal("currentIncome_changed", currentIncome)

func setMineralIncome(new_cp:int):
	mineralIncome = new_cp
	_updateIncome()
	emit_signal("currentIncome_changed", currentIncome)

func _updateIncome():
	currentIncome = lastTurnCarryOver + colonyIncome + mineralIncome

## Expenses
func getRemainingCp() -> int:
	return currentIncome - currentExpenses

func getNewMaintance() -> int:
	var maint := 0
	for shpTyp in newShips:
		print("New ship type found: ", shpTyp, " count: ", newShips[shpTyp])
		maint += getShipTypeMaintance(shpTyp) * newShips[shpTyp]
	print("New Maintance:", maint)
	return maint

func setTurnOrderBid(new_bid:int):
	turnOrderBid = new_bid
	currentExpenses = getExistingMaintance() + turnOrderBid
	emit_signal("currentExpenses_changed", currentExpenses)

## Spending
func getCostOfNewTech() -> int:
	var cost := 0
	for techTyp in newTech:
		print("New tech type found: ", techTyp, " level: ", newTech[techTyp])
		cost += getTechCost(techTyp, newTech[techTyp])
	return cost

func getTechCost(techType, level) -> int:
	match techType:
		Tech.ShipSize:
			if level < 4:
				return 5 * level
			return 20
		Tech.Attack, Tech.Defense:
			match level:
				1:
					return 20
				2:
					return 30
				3:
					return 25
				_:
					print("WARNING Invalid Attack or Defense level:", level)
					return 0
		Tech.Tactics:
			return 15
		Tech.Move:
			if level < 3:
				return 20
			elif level < 6:
				return 25
			else:
				return 20
		Tech.Terraform:
			return 20
		Tech.Exploration:
			return 15
		Tech.ShipYard:
			return 10 + (5 * level)
		_:
			print("WARNING! Tech type >", techType, "< doesn't exist!")
			return 0

func getTechMaxLevel(techType) -> int:
	match techType:
		Tech.ShipSize:
			return 6
		Tech.Attack, Tech.Defense, Tech.Tactics, Tech.ShipYard:
			return 3
		Tech.Move:
			return 7
		Tech.Terraform, Tech.Exploration:
			return 0
		_:
			print("WARNING! Tech type >", techType, "< doesn't exist!")
			return 0

func currentResearchLevel(techType) -> int:
	return researchedTech.get(techType) if \
		researchedTech.get(techType) >= newTech.get(techType) else \
		newTech.get(techType)

func getCostOfNewShips() -> int:
	var cost := 0
	for shpTyp in newShips:
		print("New ship type found: ", shpTyp, " count: ", newShips[shpTyp])
		cost += getShipTypeCost(shpTyp) * newShips[shpTyp]
	return cost

func getShipTypeCost(shipType) -> int:
	match shipType:
		ShipType.SC, ShipType.SY:
			return 6
		ShipType.DD:
			return 9
		ShipType.CA:
			return 12
		ShipType.BC:
			return 15
		ShipType.BB:
			return 20
		ShipType.DN:
			return 24
		ShipType.CO:
			return 8
		ShipType.BS:
			return 12
		ShipType.MR:
			return 5
		ShipType.DC:
			return 1
		_:
			print("WARNING! Ship type >", shipType, "< doesn't exist!")
			return 0

func getShipTypeName(shipType) -> String:
	match shipType:
		ShipType.SC:
			return "Scout"
		ShipType.DD:
			return "Destroyer"
		ShipType.CA:
			return "Cruiser"
		ShipType.BC:
			return "Battlecruiser"
		ShipType.BB:
			return "Battleship"
		ShipType.DN:
			return "Dreadnaught"
		ShipType.CO:
			return "Colony Ship"
		ShipType.BS:
			return "Base"
		ShipType.MR:
			return "Miner"
		ShipType.DC:
			return "Decoy"
		ShipType.SY:
			return "Shipyard"
		_:
			print("WARNING! Ship type >", shipType, "< doesn't exist!")
			return "NULL NAME"

func canBuildShip(shipType) -> bool:
	match shipType:
		ShipType.SC, ShipType.SY, ShipType.CO, ShipType.MR, ShipType.DC:
			return true
		ShipType.DD, ShipType.BS:
			return currentResearchLevel(Tech.ShipSize) >= 2
		ShipType.CA:
			return currentResearchLevel(Tech.ShipSize) >= 3
		ShipType.BC:
			return currentResearchLevel(Tech.ShipSize) >= 4
		ShipType.BB:
			return currentResearchLevel(Tech.ShipSize) >= 5
		ShipType.DN:
			return currentResearchLevel(Tech.ShipSize) >= 6
		_:
			print("WARNING! Ship type >", shipType, "< doesn't exist!")
			return false

func getShipTypeMaintance(shipType) -> int:
	match shipType:
		ShipType.SC, ShipType.DD:
			return 1
		ShipType.CA, ShipType.BC:
			return 2
		ShipType.BB, ShipType.DN:
			return 3
		_:
			# All other ships/bases have zero maint.
			return 0