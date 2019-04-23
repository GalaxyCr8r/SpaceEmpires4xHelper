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
var __isReady : bool = false

## Methods
func _ready():
	__isReady = true
	scrollBar.value = value
	upDown.value = value

func set_value(new_value:int):
	value = new_value
	if __last_value != value:
		__last_value = value
		emit_signal("value_changed", new_value)
		if __isReady:
			upDown.value = value
			scrollBar.value = value
			_updateLabel(value)

func get_value() -> int:
	return value

func set_max_value(new_max:int):
	if value > new_max:
		set_value(new_max)
	upDown.max_value = new_max
	scrollBar.max_value = new_max

func _updateLabel(new_value:int):
	currentValue.text = str(new_value)

## Connected Signals
func _on_CPScrollBar_value_changed(new_value:int):
	set_value(new_value)
	upDown.value = new_value
	_updateLabel(new_value)

func _on_UpDownButton_value_changed(new_value:int):
	set_value(new_value)
	scrollBar.value = new_value
	_updateLabel(new_value)
