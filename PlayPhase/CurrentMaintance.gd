extends TitleAmount

func _ready():
	Global.connect("existingShips_changed", self, "_update")
	call_deferred("_update")

func _update():
	set_value(Global.getExistingMaintance())