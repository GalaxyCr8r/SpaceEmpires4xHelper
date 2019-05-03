extends Node

## Provided Signals
signal currentIncome_changed()
signal currentExpenses_changed()

signal existingShips_changed()
signal researchedTech_changed()
signal newShips_changed()
signal newTech_changed()

## Exported vars

## Internal Vars
enum ShipType {CO, BS, MR, SY, DC, SC, DD, CA, BC, BB, DN}
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
	randomize()

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
		var new_level = newTech[techTyp]
		if new_level > 0:
			researchedTech[techTyp] = new_level
	lastTurnCarryOver = getRemainingCp()

func goToEconPhase():
	resetEconPhase()

## Empire-wide
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
	updateExpenses()

func updateExpenses():
	currentExpenses = getExistingMaintance()
	currentExpenses += getCostOfNewShips()
	currentExpenses += getCostOfNewTech()
	currentExpenses += turnOrderBid
	emit_signal("currentExpenses_changed", currentExpenses)

#########################################
### TECHNOLOGY

func resetTech():
	researchedTech = {Tech.ShipSize: 1, Tech.Move: 1, Tech.ShipYard: 1}

func setNewTechLevel(techType, level):
	if level < 0 or level > getTechMaxLevel(techType):
		return false
	newTech[techType] = level
	emit_signal("newTech_changed")
	updateExpenses()

func getCostOfNewTech() -> int:
	var cost := 0
	for techTyp in newTech:
		var new_level = newTech[techTyp]
		if researchedTech.get(techTyp, 0) < new_level:
			print("New tech type found: ", techTyp, " level: ", new_level)
			cost += getTechCost(techTyp, new_level)
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

func getTechName(techType) -> String:
	match techType:
		Tech.ShipSize:
			return "Ship Size"
		Tech.Defense:
			return "Defense"
		Tech.Attack:
			return "Attack"
		Tech.Tactics:
			return "Tactics"
		Tech.Move:
			return "Movement"
		Tech.Terraform:
			return "Terraform"
		Tech.Exploration:
			return "Exploration"
		Tech.ShipYard:
			return "Ship Yards"
		_:
			print("WARNING! Tech type >", techType, "< doesn't exist!")
			return "NULL TYPE"

func getTechMaxLevel(techType) -> int:
	match techType:
		Tech.ShipSize:
			return 6
		Tech.Attack, Tech.Defense, Tech.Tactics, Tech.ShipYard:
			return 3
		Tech.Move:
			return 7
		Tech.Terraform, Tech.Exploration:
			return 1
		_:
			print("WARNING! Tech type >", techType, "< doesn't exist!")
			return 0

func currentResearchLevel(techType) -> int:
	return researchedTech.get(techType, 0) if \
		researchedTech.get(techType, 0) >= newTech.get(techType, 0) else \
		newTech.get(techType, 0)

func isTechMaxLevel(techType) -> bool:
	return researchedTech.get(techType, 0) == getTechMaxLevel(techType)

func collectSpaceWreck():
	var dieRoll := randi() % 10 + 1
	var tech = Tech.ShipSize
	if dieRoll >= 3:
		tech = Tech.Attack
	if dieRoll >= 5:
		tech = Tech.Defense
	if dieRoll >= 7:
		tech = Tech.Tactics
	if dieRoll >= 8:
		tech = Tech.Move
	if dieRoll >= 10:
		tech = Tech.ShipYard
	if researchedTech.get(tech, 0) < getTechMaxLevel(tech):
		researchedTech[tech] = researchedTech.get(tech, 0) + 1
		emit_signal("researchedTech_changed")
	return tech

#########################################
### SHIPS
func resetExistingShips():
	existingShips = {ShipType.SC: 3, ShipType.CO: 3, ShipType.SY: 4, ShipType.MR: 1}
	emit_signal("existingShips_changed")

func removeAnExistingShip(shipType):
	if existingShips[shipType] > 0:
		existingShips[shipType] -= 1
		emit_signal("existingShips_changed")

func setNewShipAmount(shipType, amount):
	if amount < 0:
		return false
	newShips[shipType] = amount
	emit_signal("newShips_changed")
	updateExpenses()

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