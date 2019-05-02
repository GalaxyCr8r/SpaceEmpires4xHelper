extends VBoxContainer

## Provided Signals
#signal value_changed(new_value)

## Exported vars
#export var value : int = 0 setget set_value, get_value

## Internal Vars
#onready var  : =

## Methods
func _ready():
	$VBoxContainer/PanelContainer/VBoxContainer/TurnOrderBid.value = Global.turnOrderBid

## Connected Signals

func _on_EconPhaseButton_button_up():
	call_deferred("_goToEconPhase")

func _goToEconPhase():
	get_tree().change_scene("res://EconPhase/EconomicPhase.tscn")
	Global.goToEconPhase()
