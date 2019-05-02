extends HBoxContainer
class_name UpDownButton

## Provided Signals
signal value_changed(new_value)

## Exported vars
export var value : int = 0 setget set_value, get_value
export var min_value : int = 0
export var max_value : int = 2
export var step : int = 1
export var disabled : bool = false setget set_disabled

## Internal Vars
onready var minus : Button = $MinusButton
onready var plus : Button = $PlusButton
onready var __last_value : int = value

## Methods
func _ready():
	call_deferred("_updateAvailability", true)

func set_value(new_value : int):
	value = new_value
	call_deferred("_updateAvailability")

func get_value() -> int:
	return value

func set_disabled(new_setting):
	disabled = new_setting
	call_deferred("_updateAvailability")

func _updateAvailability(force:bool = false):
	## Had to add this because this is STILL getting called before things are ready when going from Play to Econ!
	if minus == null:
		call_deferred("_updateAvailability", force)
		return
	
	## If we want to force the change, or if the value has changed
	if force or value != __last_value:
		__last_value = value
		emit_signal("value_changed", value)
		
		minus.disabled = disabled
		plus.disabled = disabled
		
		if disabled:
			return
		
		if value < min_value:
			value = min_value
		if value == min_value:
			minus.set_disabled(true)
			
		if value > max_value:
			value = max_value
		if value == max_value:
			plus.set_disabled(true)

## Connected Signals
func _on_MinusButton_button_up():
	value -= step
	call_deferred("_updateAvailability")

func _on_PlusButton_button_up():
	value += step
	call_deferred("_updateAvailability")
