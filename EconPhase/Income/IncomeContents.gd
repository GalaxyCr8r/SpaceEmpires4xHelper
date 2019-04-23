extends MarginContainer

## Provided Signals
signal value_changed(updated_subTotal)

## Exported vars

## Internal Vars
onready var carryOverAmount : TitleAmount = $VBoxContainer/Misc/CarryOver
onready var subTotalAmount : TitleAmount = $VBoxContainer/Misc/SubTotal
var subTotalCp := 0

var _hwCp:int = 0
var _1ColonyCp:int = 0
var _3ColonyCp:int = 0
var _5ColonyCp:int = 0
var _5MineralCp:int = 0
var _10MineralCp:int = 0

var __ready = false

## Methods
func _ready():
	__ready = true
	emit_signal("value_changed", subTotalCp)

func _updateSubTotal():
	subTotalCp = _hwCp + Global.lastTurnCarryOver
	subTotalCp += _1ColonyCp + _3ColonyCp + _5ColonyCp
	subTotalCp += _5MineralCp + _10MineralCp
	Global.currentIncomeCp = subTotalCp
	emit_signal("value_changed", subTotalCp)
	
	if __ready:
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
