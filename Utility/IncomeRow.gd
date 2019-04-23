extends HBoxContainer
class_name IncomeRow

## Provided Signals
signal value_changed(new_value)

## Exported vars
export var value : int = 0 setget set_value, get_value

## Internal Vars
onready var amount : Label = $Amount
onready var upDown : UpDownButton = $UpDownButton
onready var __last_value : int = value

## Methods
func set_value(new_value:int):
	value = new_value
	if __last_value != value:
		__last_value = value
		emit_signal("value_changed", new_value)
		upDown.set_value(new_value)
		amount.text = str(new_value)

func get_value() -> int:
	return value

## Connected Signals
func _on_UpDownButton_value_changed(new_value):
	set_value(new_value)