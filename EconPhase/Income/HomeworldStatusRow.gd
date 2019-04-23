extends ScrollBarRow

func _ready():
	emit_signal("value_changed", value)

func _updateLabel(new_value:int):
	if value > 0:
		self.currentValue.add_color_override("font_color", Color(1,1,1))
		self.currentValue.text = str(new_value) + " CP"
	else:
		self.currentValue.add_color_override("font_color", Color(1,0,0))
		self.currentValue.text = "DEAD"
