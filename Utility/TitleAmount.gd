extends VBoxContainer
tool
class_name TitleAmount

export var title := "Title" setget set_title
export var value := 0 setget set_value,get_value
export var prefix : String = "" setget set_prefix
export var postfix : String = "" setget set_postfix
export var redNegative : bool = true

onready var titleLabel : Label = $Title
onready var amount : Label = $Amount

func _updateLabel():
	if !amount:
		return
	titleLabel.text = title
	amount.add_color_override("font_color", Color(1,1,1))
	if redNegative:
		if value < 0:
			amount.add_color_override("font_color", Color(1,0,0))
	amount.text = prefix + str(value) + postfix

func set_title(new_title:String):
	title = new_title
	call_deferred("_updateLabel")

func set_value(new_value:int):
	value = new_value
	call_deferred("_updateLabel")

func get_value():
	return value

func set_prefix(new_prefix:String):
	prefix = new_prefix
	call_deferred("_updateLabel")

func set_postfix(new_postfix:String):
	postfix = new_postfix
	call_deferred("_updateLabel")

func set_redNegative(showRed:bool):
	redNegative=showRed
	call_deferred("_updateLabel")