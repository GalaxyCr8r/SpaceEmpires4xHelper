extends MarginContainer

## Provided Signals
signal incomeTotal_changed(new_value)

## Exported vars

## Internal Vars
onready var carryOverAmount : TitleAmount = $VBoxContainer/Misc/CarryOver
onready var subTotalAmount : TitleAmount = $VBoxContainer/Misc/SubTotal
onready var spaceWrecksCheckButton : CheckBox = $VBoxContainer/ScrollableIncomeSources/IncomeSources/VBoxContainer/SpaceWrecks/CheckButton
onready var spaceWrecksAmount : Label = $VBoxContainer/ScrollableIncomeSources/IncomeSources/VBoxContainer/SpaceWrecks/Amount
onready var spaceWrecksButton : Button = $VBoxContainer/ScrollableIncomeSources/IncomeSources/VBoxContainer/SpaceWrecks/Button
onready var collectedWreck : Label = $VBoxContainer/ScrollableIncomeSources/IncomeSources/VBoxContainer/Collected

var subTotalCp := 0

var _hwCp:int = 0
var _1ColonyCp:int = 0
var _3ColonyCp:int = 0
var _5ColonyCp:int = 0
var _5MineralCp:int = 0
var _10MineralCp:int = 0

## Methods
func _ready():
	emit_signal("incomeTotal_changed", subTotalCp)
	collectedWreck.text = ""

func _updateSubTotal():
	subTotalCp = _hwCp + Global.lastTurnCarryOver
	subTotalCp += _1ColonyCp + _3ColonyCp + _5ColonyCp
	subTotalCp += _5MineralCp + _10MineralCp
	Global.colonyIncome = _hwCp + _1ColonyCp + _3ColonyCp + _5ColonyCp
	Global.mineralIncome = _5MineralCp + _10MineralCp
	emit_signal("incomeTotal_changed", subTotalCp)
	
	carryOverAmount.value = Global.lastTurnCarryOver
	subTotalAmount.value = subTotalCp

## Connected Signals
func _on_HomeworldStatusRow_value_changed(new_value):
	_hwCp = new_value
	call_deferred("_updateSubTotal")

func _on_1CpColonyRow_value_changed(new_value):
	_1ColonyCp = new_value
	call_deferred("_updateSubTotal")

func _on_3CpColonyRow_value_changed(new_value):
	_3ColonyCp = new_value * 3
	call_deferred("_updateSubTotal")

func _on_5CpColonyRow_value_changed(new_value):
	_5ColonyCp = new_value * 5
	call_deferred("_updateSubTotal")

func _on_5CpMineral_value_changed(new_value):
	_5MineralCp = new_value * 5
	call_deferred("_updateSubTotal")

func _on_10CpMineral_value_changed(new_value):
	_10MineralCp = new_value * 10
	call_deferred("_updateSubTotal")

# Sphess wrecks
var amountOfSpaceWrecks := 0
func _on_CheckButton_toggled(button_pressed):
	spaceWrecksButton.disabled = !button_pressed

func _on_Button_pressed():
	spaceWrecksCheckButton.pressed = false
	spaceWrecksButton.disabled = true
	amountOfSpaceWrecks += 1
	spaceWrecksAmount.text = str(amountOfSpaceWrecks)
	
	var spaceWreckType = Global.collectSpaceWreck()
	collectedWreck.text = "Collected: " + Global.getTechName(spaceWreckType) +\
		" Level " + str(Global.researchedTech[spaceWreckType])
