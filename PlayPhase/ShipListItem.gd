extends HBoxContainer

## Provided Signals
signal kill_pressed(shipType)
signal info_pressed(shipType)

## Exported vars
export var shipName : String = "ShipNameHere"
export var amount : int = 0

## Internal Vars
onready var nameLabel : Label = $Name
onready var amountLabel : Label = $Amount

var shipType := -1

## Methods
func set(new_shipType, amount):
	shipType = new_shipType
	nameLabel.text = Global.getShipTypeName(shipType)
	amountLabel.text = "x" + str(amount)

## Connected Signals
func _on_KillButton_pressed():
	emit_signal("kill_pressed", shipType)

func _on_InfoButton_pressed():
	emit_signal("info_pressed", shipType)
