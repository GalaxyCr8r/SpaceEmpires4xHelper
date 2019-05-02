extends MarginContainer
## Luckily this script is just to update the various labels and continue the app.

## Provided Signals
#signal value_changed(new_value)

## Exported vars
#export var value : int = 0 setget set_value, get_value

## Internal Vars
onready var colonyCp : TitleAmount = $VBoxContainer/ColonyCp
onready var mineralCp : TitleAmount = $VBoxContainer/MineralCp
onready var maintance : TitleAmount = $VBoxContainer/Maintance
onready var turnOrder : TitleAmount = $VBoxContainer/TurnOrder
onready var techSpending : TitleAmount = $VBoxContainer/Expenses/TechSpending
onready var shipSpending : TitleAmount = $VBoxContainer/Expenses/ShipSpending
onready var remainingCp : TitleAmount = $VBoxContainer/RemainingCp

## Methods
func _ready():
	Global.connect("currentIncome_changed", self, "_updateAny")
	Global.connect("currentExpenses_changed", self, "_updateAny")
	call_deferred("_updateAll")

func _updateAny(amt):
	_updateAll()
	
func _updateAll():
	colonyCp.value = Global.colonyIncome
	mineralCp.value = Global.mineralIncome
	maintance.value = Global.getExistingMaintance()
	turnOrder.value = Global.turnOrderBid
	techSpending.value = Global.getCostOfNewTech()
	shipSpending.value = Global.getCostOfNewShips()
	remainingCp.value = Global.getRemainingCp()
	
	## TODO make an onready var
	$VBoxContainer/DoneWithEconPhase/DoneButton.disabled = Global.getRemainingCp() < 0

## Connected Signals
func _on_Done_button_up():
	if Global.getRemainingCp() >= 0:
		call_deferred("_changeScene")

func _changeScene():
	get_tree().change_scene("res://PlayPhase/PlayPhase.tscn")
	Global.goToPlayPhase()
