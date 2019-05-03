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
onready var checkbox : UpDownButton = $HBoxContainer/CheckBox
onready var costLabel : Label = $HBoxContainer/Cost

var techType
var level
var upgrading : bool = false
var disabled : bool = false

## Methods
func _ready():
	Global.connect("researchedTech_changed", self, "_researchedTech_changed")
	Global.connect("currentIncome_changed", self, "_update")
	Global.connect("currentExpenses_changed", self, "_update")
	pass

func setItem(type):
	techType = type
	typeLabel.text = Global.getTechName(techType)
	currentAmount.text = str(Global.researchedTech.get(techType, 0))
	newAmount.visible = false
	level = Global.researchedTech.get(techType, 0) + 1
	
	disabled = Global.isTechMaxLevel(techType)
	if disabled:
		costLabel.text = "N/A" + " CP"
		costLabel.add_color_override("font_color", Color(1,1,1,0.5))
		checkbox.disabled = true
	else:
		costLabel.text = str(Global.getTechCost(techType, level)) + " CP"
	_update()

## Connected Signals
func _researchedTech_changed():
	if Global.researchedTech.get(techType, 0) + 1 != level:
		setItem(techType)

func _update(any = 0):
	if disabled:
		return
	
	checkbox.disabled = false
	costLabel.add_color_override("font_color", Color(1,1,1))
	if Global.getRemainingCp() < Global.getTechCost(techType, level):
		costLabel.add_color_override("font_color", Color(1,0,0))
		if !upgrading:
			checkbox.disabled = true
	
	newAmount.visible = false
	if upgrading:
		newAmount.visible = true

func _on_CheckBox_toggled(button_pressed):
	upgrading = button_pressed
	var new_level = level if button_pressed else Global.researchedTech.get(techType, 0)
	Global.setNewTechLevel(techType, new_level)
	_update()
