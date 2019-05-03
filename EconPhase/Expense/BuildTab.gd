extends Tabs

## Provided Signals

## Exported vars
export var listItem : PackedScene

## Internal Vars
onready var shipList : VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/ShipList
onready var buildCost : TitleAmount = $MarginContainer/VBoxContainer/CostAndMaint/BuildCost
onready var incMaint : TitleAmount = $MarginContainer/VBoxContainer/CostAndMaint/IncMaint

func _ready():
	for shipType in Global.ShipType.values():
		var shipItem = listItem.instance()
		shipList.add_child(shipItem)
		shipItem.setItem(shipType)
	Global.connect("newShips_changed", self, "_update")

func _update():
	incMaint.value = Global.getNewMaintance()
	buildCost.value = Global.getCostOfNewShips()