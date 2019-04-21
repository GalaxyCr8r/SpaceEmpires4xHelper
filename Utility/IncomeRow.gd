extends HBoxContainer
class_name IncomeRow

export var value : int = 0 setget set_value, get_value

onready var amount : Label = $Amount
onready var upDown : UpDownButton = $UpDownButton

func set_value(new_value:int):
	value = new_value
	upDown.set_value(new_value)

func get_value() -> int:
	return value

func _on_UpDownButton_value_changed(new_value):
	amount.text = str(new_value)