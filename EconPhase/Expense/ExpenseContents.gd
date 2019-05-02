extends MarginContainer

## Provided Signals
signal expenseTotal_changed(new_value)

## Exported vars

## Internal Vars
onready var exiMaint:TitleAmount = $VBoxContainer/ExistingMaint
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
	# Do NOT set res/build cost here because by default don't build/research anything.
	Global.connect("currentIncome_changed", self, "_updateMax")
	call_deferred("_updateAll")

func _updateMax(currentIncome):
	turnOrderBidRow.set_max_value(currentIncome)
	_updateAll()

func _updateAll():
	# Update summaries
	Global.turnOrderBid = turnOrderBid
	exiMaint.value = Global.getExistingMaintance()
	miscCost.value = exiMaint.value + turnOrderBid
	resCost.value = Global.getCostOfNewTech()
	buildCost.value = Global.getCostOfNewShips()
	availableCp.value = Global.getRemainingCp()

## Connected Signals
func _on_TurnOrderBid_value_changed(new_value):
	turnOrderBid = new_value
	Global.turnOrderBid = turnOrderBid
	call_deferred("_updateAll")

func _on_Research_value_changed(new_value):
	resCost.value = new_value
	call_deferred("_updateAll")

func _on_Build_value_changed(new_value):
	buildCost.value = new_value
	call_deferred("_updateAll")
