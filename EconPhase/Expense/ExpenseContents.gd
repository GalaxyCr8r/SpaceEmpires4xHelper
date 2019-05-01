extends MarginContainer

## Provided Signals
signal expenseTotal_changed(new_value)

## Exported vars

## Internal Vars
onready var maintRow:IncomeRow = $VBoxContainer/VBoxContainer/MaintRow
onready var miscCost:TitleAmount = $VBoxContainer/Summary/MiscCost
onready var resCost:TitleAmount = $VBoxContainer/Summary/ResearchCost
onready var buildCost:TitleAmount = $VBoxContainer/Summary/BuildCost
onready var availableCp:TitleAmount = $VBoxContainer/Summary/RemainingCp
onready var turnOrderBidRow:ScrollBarRow = $VBoxContainer/TurnOrderBid/ScrollBarRow

var subTotal := 0
var maintance := 0
var turnOrderBid := 0

## Methods
func _ready():
	maintRow.set_value(Global.lastTurnMaintance)
	# Do NOT set res/build cost here because by default don't build/research anything.
	Global.connect("currentIncome_changed", self, "_updateMax")

func _updateMax(currentIncome):
	turnOrderBidRow.set_max_value(Global.currentIncomeCp)

func _updateAll():
	# Update summaries
	miscCost.value = maintance + turnOrderBid
	
	# Update global expense subtotal
	subTotal = miscCost.value
	subTotal += resCost.value
	subTotal += buildCost.value
	Global.currentExpenses = subTotal
	availableCp.value = Global.getRemainingCp()

## Connected Signals
func _on_TurnOrderBid_value_changed(new_value):
	turnOrderBid = new_value
	Global.turnOrderBid = turnOrderBid
	call_deferred("_updateAll")

func _on_Maintance_value_changed(new_value):
	maintance = new_value
	call_deferred("_updateAll")

func _on_Research_value_changed(new_value):
	resCost.value = new_value
	call_deferred("_updateAll")

func _on_Build_value_changed(new_value):
	buildCost.value = new_value
	call_deferred("_updateAll")
