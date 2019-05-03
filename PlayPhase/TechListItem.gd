extends HBoxContainer

## Provided Signals
signal info_pressed(techType) ## See #6

## Exported vars
export var techName : String = "TechNameHere"
export var amount : int = 0

## Internal Vars
onready var nameLabel : Label = $Name
onready var levelLabel : Label = $Level

var techType := -1

## Methods
func set(new_techType, amount):
	techType = new_techType
	nameLabel.text = Global.getTechName(techType)
	levelLabel.text = "Level " + str(amount)

## Connected Signals
func _on_InfoButton_pressed():
	emit_signal("info_pressed", techType)
