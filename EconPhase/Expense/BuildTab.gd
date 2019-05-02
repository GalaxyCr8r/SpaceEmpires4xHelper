extends Tabs

## Provided Signals
signal value_changed(new_value)

## Exported vars
export var listItem : PackedScene

## Internal Vars
onready var shipList : VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/ShipList
onready var buildCost : TitleAmount = $MarginContainer/VBoxContainer/CostAndMaint/BuildCost
onready var incMaint : TitleAmount = $MarginContainer/VBoxContainer/CostAndMaint/IncMaint

var cost : int = 0
onready var __last_cost : int = cost

func _ready():
	for shipType in Global.ShipType.values():
		var shipItem = listItem.instance()
		shipList.add_child(shipItem)
		shipItem.setItem(shipType)
	pass
	Global.connect("newShips_changed", self, "_update")
	#Global.connect("currentIncome_changed", self, "_updateMax")

func _update():
	incMaint.value = Global.getNewMaintance()
	buildCost.value = Global.getCostOfNewShips()

#func _on_ScrollBarRow_value_changed(new_value):
#	cost = new_value
#	if __last_cost != cost:
#		__last_cost = cost
#		emit_signal("value_changed", cost)
