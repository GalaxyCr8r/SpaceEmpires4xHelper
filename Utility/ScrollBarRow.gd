extends HBoxContainer
class_name ScrollBarRow

export var value : int = 20 setget set_value, get_value

onready var currentValue : Label = $CurrentValue
onready var scrollBar : ScrollBar = $ScrollBar
onready var upDown : UpDownButton = $UpDownButton

var __isReady : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	__isReady = true
	scrollBar.value = value
	upDown.value = value

func set_value(new_value:int):
	value = new_value
	if !__isReady:
		return
	upDown.value = new_value
	scrollBar.value = new_value
	_updateLabel(new_value)

func get_value() -> int:
	return value

func set_max_value(new_max:int):
	if value > new_max:
		set_value(new_max)
	upDown.max_value = new_max
	scrollBar.max_value = new_max

func _updateLabel(new_value:int):
	currentValue.text = str(new_value)

func _on_CPScrollBar_value_changed(new_value:int):
	value = new_value
	upDown.value = new_value
	_updateLabel(new_value)

func _on_UpDownButton_value_changed(new_value:int):
	value = new_value
	scrollBar.value = new_value
	_updateLabel(new_value)
