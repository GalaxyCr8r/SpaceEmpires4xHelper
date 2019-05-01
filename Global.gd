extends Node

## Provided Signals
signal currentIncome_changed()
signal currentExpenses_changed()
signal currentEconPhaseValues_changed()

## Exported vars
#export var STARTING_SCOUTS := 3

## Internal Vars
enum ShipType {SC, DD, CA, BC, BB, DN, CO, BS, MR, SY}
enum Tech {
	ShipSize, 
	Attack, 
	Defense, 
	Tactics, 
	Move, 
	ShipYards, 
	Terraforming, 
	Exploration
}

## Current Econ Phase
var colonyIncome := 20 setget setColonyIncome
var mineralIncome := 0 setget setMineralIncome

var turnOrderBid := 0 setget setTurnOrderBid
var newTech := {}
var newShips := {}
var currentIncomeCp := 0 setget ,getCurrentCp
var currentExpenses := 0 setget ,getExpenses

## Last Econ Phase
var researchedTech := {}
var constructedShips := {}
var lastTurnCarryOver := 3
var lastTurnMaintance := 7
onready var currentMaintance := 0 setget ,getCurrentMaintance

## Methods
func _ready():
	resetConstructedShips()
	resetTech()

func resetEconPhase():
	colonyIncome = 20
	mineralIncome = 0
	
	turnOrderBid = 0
	newTech = {}
	newShips = {}

## Empire-wide
func resetConstructedShips():
	constructedShips = {ShipType.SC: 3}

func resetTech():
	researchedTech = {Tech.ShipSize: 1, Tech.Move: 1, Tech.ShipYards: 1}

## Income
func setColonyIncome(new_cp:int):
	colonyIncome = new_cp
	currentIncomeCp = lastTurnCarryOver + colonyIncome + mineralIncome
	emit_signal("currentIncome_changed", currentIncomeCp)

func setMineralIncome(new_cp:int):
	mineralIncome = new_cp
	currentIncomeCp = lastTurnCarryOver + colonyIncome + mineralIncome
	emit_signal("currentIncome_changed", currentIncomeCp)
	
func getCurrentCp() -> int:
	return lastTurnCarryOver + colonyIncome + mineralIncome

## Expenses
func getRemainingCp() -> int:
	return currentIncomeCp - currentExpenses

func getCurrentMaintance() -> int:
	var maint := 0
	for shpTyp in constructedShips:
		print("Constructed ship type found: ", shpTyp, " from: ", constructedShips[shpTyp])
		maint += getShipTypeMaintance(shpTyp) * constructedShips[shpTyp]
	for shpTyp in newShips:
		print("New ship type found: ", shpTyp, " from: ", newShips[shpTyp])
		maint += getShipTypeMaintance(shpTyp) * newShips[shpTyp]
	return maint

func setTurnOrderBid(new_bid:int):
	turnOrderBid = new_bid
	currentExpenses = getCurrentMaintance() + turnOrderBid
	emit_signal("currentExpenses_changed", currentExpenses)

func getExpenses() -> int:
	return currentExpenses

## Spending

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