extends Node

## Provided Signals
signal currentIncome_changed()
signal currentExpenses_changed()

## Exported vars
export var STARTING_SCOUTS := 3

## Internal Vars
var currentIncomeCp := 0 setget setCurrentCp, getCurrentCp
var currentExpenses := 0 setget setExpenses, getExpenses
var remainingCp := 0

var technology = {}
var lastTurnCarryOver := 0
var lastTurnOrderBid := 0
var lastTurnMaintance := 0
onready var currentMaintance := STARTING_SCOUTS

## Methods
func _ready():
	pass # Replace with function body.

func _updateRemainingCp():
	remainingCp = currentIncomeCp - currentExpenses

func setCurrentCp(new_cp:int):
	currentIncomeCp = new_cp
	_updateRemainingCp()
	emit_signal("currentIncome_changed", currentIncomeCp)
	
func getCurrentCp() -> int:
	return currentIncomeCp

func setExpenses(new_expenses:int):
	currentExpenses = new_expenses
	_updateRemainingCp()
	emit_signal("currentExpenses_changed", currentExpenses)

func getExpenses() -> int:
	return currentExpenses