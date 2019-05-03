extends VBoxContainer

## Provided Signals
#signal value_changed(new_value)

## Exported vars
export var shipListItem : PackedScene
export var techListItem : PackedScene

## Internal Vars
onready var shipList : VBoxContainer = $VBoxContainer/PanelContainer/VBoxContainer/TabContainer/Ships/ScrollContainer/ShipList
onready var techList : VBoxContainer = $VBoxContainer/PanelContainer/VBoxContainer/TabContainer/Tech/ScrollContainer2/TechList
onready var turnOrderBid : TitleAmount = $VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer2/TurnOrderBid

## Methods
func _ready():
	turnOrderBid.value = Global.turnOrderBid
	
	for shipType in Global.existingShips:
		if Global.existingShips[shipType] > 0:
			var shipItem := shipListItem.instance()
			shipList.add_child(shipItem)
			shipItem.set(shipType, Global.existingShips[shipType])
			shipItem.connect("kill_pressed", self, "_shipType_killed")
			#TODO Connect info button
	
	for techType in Global.researchedTech:
		var techItem := techListItem.instance()
		techList.add_child(techItem)
		techItem.set(techType, Global.researchedTech[techType])
		#TODO Connect info button

func _updateShipList():
	# This method does not take into account GAINING ships,
	# because as far as I know, that's impossible between econ phases.
	for shipItem in shipList.get_children():
		var shipType = shipItem.shipType
		if Global.existingShips[shipType] > 0:
			shipItem.set(shipType, Global.existingShips[shipType])
		else:
			shipList.call_deferred("remove_child", shipItem)

## Connected Signals
func _shipType_killed(shipType):
	Global.removeAnExistingShip(shipType)
	_updateShipList()

func _on_EconPhaseButton_button_up():
	call_deferred("_goToEconPhase")

func _goToEconPhase():
	Global.goToEconPhase()
	get_tree().change_scene("res://EconPhase/EconomicPhase.tscn")
