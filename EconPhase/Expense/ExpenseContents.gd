extends MarginContainer

## Provided Signals
signal value_changed(new_value)

## Exported vars

## Internal Vars
onready var miscCost:TitleAmount = $VBoxContainer/Summary/MiscCost
onready var resCost:TitleAmount = $VBoxContainer/Summary/ResearchCost
onready var buildCost:TitleAmount = $VBoxContainer/Summary/BuildCost

var subTotal := 0
var maintance := 0
var turnOrderBid := 0

## Methods
func _ready():
	miscCost.set_value(Global.lastTurnMaintance)

func _updateAll():
	# Update summaries
	miscCost.value = maintance + turnOrderBid
	
	# Update global expense subtotal
	subTotal = maintance + turnOrderBid
	Global.currentExpenses = subTotal

## Connected Signals
func _on_TurnOrderBid_value_changed(new_value):
	turnOrderBid = new_value
	call_deferred("_updateAll")

func _on_Maintance_value_changed(new_value):
	maintance = new_value
	call_deferred("_updateAll")
