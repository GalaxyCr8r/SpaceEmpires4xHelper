extends ScrollBarRow

func _updateLabel(new_value:int):
	if value > 0:
		self.currentValue.text = str(new_value) + " CP"
	else:
		self.currentValue.text = "DEAD"
