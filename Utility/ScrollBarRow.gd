extends HBoxContainer
class_name ScrollBarRow

## Provided Signals
signal value_changed(new_value)

## Exported vars
export var value : int = 20 setget set_value, get_value

## Internal Vars
onready var currentValue : Label = $CurrentValue
onready var scrollBar : ScrollBar = $ScrollBar
onready var upDown : UpDownButton = $UpDownButton
onready var __last_value : int = value

## Methods
func _ready():
	scrollBar.value = value
	upDown.value = value

func set_value(new_value:int):
	value = new_value
	if __last_value != value:
		__last_value = value
		emit_signal("value_changed", new_value)
		call_deferred("_updateAll")

func get_value() -> int:
	return value

func set_max_value(new_max:int):
	if value > new_max:
		set_value(new_max)
	upDown.max_value = new_max
	upDown._updateAvailability(true)
	scrollBar.max_value = new_max

func _updateAll():
	if upDown == null:
		call_deferred("_updateAll")
		return
	upDown.value = value
	scrollBar.value = value
	_updateLabel()

func _updateLabel():
	currentValue.text = str(value)

## Connected Signals
func _on_CPScrollBar_value_changed(new_value:int):
	set_value(new_value)
	upDown.value = new_value
	call_deferred("_updateLabel")

func _on_UpDownButton_value_changed(new_value:int):
	if scrollBar == null:
		call_deferred("_on_UpDownButton_value_changed", new_value)
		return
	set_value(new_value)
	scrollBar.value = new_value
	call_deferred("_updateLabel")
