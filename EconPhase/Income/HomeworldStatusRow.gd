extends HBoxContainer

export var value : int = 20 setget set_value, get_value

onready var currentCp : Label = $CurrentCP
onready var cpScrollBar : ScrollBar = $CPScrollBar
onready var upDown : UpDownButton = $UpDownButton

# Called when the node enters the scene tree for the first time.
func _ready():
	cpScrollBar.value = value
	upDown.value = value

func set_value(new_value:int):
	value = new_value
	upDown.value = new_value
	cpScrollBar.value = new_value
	_updateLabel(new_value)

func get_value() -> int:
	return value

func _updateLabel(new_value:int):
	if value > 0:
		currentCp.text = str(new_value) + " CP"
	else:
		currentCp.text = "DEAD"

func _on_CPScrollBar_value_changed(new_value:int):
	value = new_value
	upDown.value = new_value
	_updateLabel(new_value)

func _on_UpDownButton_value_changed(new_value:int):
	value = new_value
	cpScrollBar.value = new_value
	_updateLabel(new_value)
