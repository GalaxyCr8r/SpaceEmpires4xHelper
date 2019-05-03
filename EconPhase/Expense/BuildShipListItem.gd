extends MarginContainer

## Provided Signals
signal info_pressed(shipType)

## Exported vars
#export var value : int = 0 setget set_value, get_value

## Internal Vars
onready var infoButton : Button = $HBoxContainer/InfoButton
onready var typeLabel : Label = $HBoxContainer/Type
onready var currentAmount : Label = $HBoxContainer/Amount/Current
onready var newAmount : Label = $HBoxContainer/Amount/New
onready var upDown : UpDownButton = $HBoxContainer/UpDownButton
onready var costLabel : Label = $HBoxContainer/Cost

var shipType
var amount

## Methods
func _ready():
	#Global.connect("newTech_changed", self, "_updateTechReady")
	Global.connect("currentIncome_changed", self, "_updateColours")
	Global.connect("currentExpenses_changed", self, "_updateColours")

func setItem(type):
	shipType = type
	typeLabel.text = Global.getShipTypeName(shipType)
	costLabel.text = str(Global.getShipTypeCost(shipType)) + " CP"
	_update()
	#Global.connect("")

## Connected Signals
func _updateColours(acceptAny = 0):
	var disabled : bool = !Global.canBuildShip(shipType)
	upDown.disabled = disabled
	typeLabel.add_color_override("font_color", Color(1,1,1))
	costLabel.add_color_override("font_color", Color(1,1,1))
	if disabled:
		typeLabel.add_color_override("font_color", Color(1,1,1,0.5))
		costLabel.add_color_override("font_color", Color(1,1,1,0.5))
	else:
		if Global.getRemainingCp() < Global.getShipTypeCost(shipType):
			costLabel.add_color_override("font_color", Color(1,0,0))	

func _update():
	currentAmount.text = str(Global.existingShips.get(shipType, 0))
	
	_updateColours()
	
	var new : int = Global.newShips.get(shipType, 0)
	if new > 0:
		newAmount.visible = true
		newAmount.text = "+" + str(amount)
	else:
		newAmount.visible = false

func _on_UpDownButton_value_changed(new_value):
	amount = new_value
	Global.setNewShipAmount(shipType, amount)
	_update()

func _updateTechReady():
	_updateColours()