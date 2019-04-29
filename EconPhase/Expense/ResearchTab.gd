extends Tabs

## Provided Signals
signal value_changed(new_value)

## Exported vars
export var cost : int = 0

## Internal Vars
onready var __last_cost : int = cost

func _ready():
	Global.connect("currentIncome_changed", self, "_updateMax")

func _updateMax(currentIncome):
	$MarginContainer/CenterContainer/VBoxContainer/ScrollBarRow.set_max_value(currentIncome)

func _on_ScrollBarRow_value_changed(new_value):
	cost = new_value
	if __last_cost != cost:
		__last_cost = cost
		emit_signal("value_changed", cost)
