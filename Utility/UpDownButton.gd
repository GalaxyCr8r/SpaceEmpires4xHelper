extends HBoxContainer
class_name UpDownButton

## Provided Signals
signal value_changed(new_value)

## Exported vars
export var value : int = 0 setget set_value, get_value
export var min_value : int = 0
export var max_value : int = 2
export var step : int = 1

## Internal Vars
onready var minus : Button = $MinusButton
onready var plus : Button = $PlusButton
onready var __last_value : int = value

var __isReady : bool = false

## Methods
func _ready():
	__isReady = true
	_updateAvailability()

func set_value(new_value : int):
	value = new_value
	_updateAvailability()

func get_value() -> int:
	return value

func _updateAvailability():
	if !__isReady:
		return
	
	minus.set_disabled(false)
	plus.set_disabled(false)
	if value < min_value:
		value = min_value
	if value == min_value:
		minus.set_disabled(true)
		
	if value > max_value:
		value = max_value
	if value == max_value:
		plus.set_disabled(true)
	
	if value != __last_value:
		emit_signal("value_changed", value)
		__last_value = value

## Connected Signals
func _on_MinusButton_button_up():
	value -= step
	_updateAvailability()

func _on_PlusButton_button_up():
	value += step
	_updateAvailability()
