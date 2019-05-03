extends ScrollBarRow

func _ready():
	emit_signal("value_changed", value)

func _updateLabel():
	if value > 0:
		self.currentValue.add_color_override("font_color", Color(1,1,1))
		self.currentValue.text = str(value) + " CP"
	else:
		self.currentValue.add_color_override("font_color", Color(1,0,0))
		self.currentValue.text = "DEAD"
